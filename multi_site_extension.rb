require_dependency 'application'

class MultiSiteExtension < Spree::Extension
  version "1.0"
  description "Extention that will allow the store to support multiple sites each having their own taxonomies, products and orders"
  url "git://github.com/tunagami/spree-multi-site.git"

  def activate
    # admin.tabs.add "Multi Site", "/admin/multi_site", :after => "Layouts", :visibility => [:all]

    #############################################################################
    # Overriding Spree Core Models
    Taxonomy.class_eval do
      belongs_to :site
    end

    Product.class_eval do
      belongs_to :site
      named_scope :by_site, lambda {|site| {:conditions => ["products.site_id = ?", site.id]}}
      named_scope :by_site_with_children, lambda {|site| {:conditions => ["products.site_id in (?)", site.self_and_children]}}
    end
    
    Order.class_eval do
      belongs_to :site
    end
    #############################################################################
    

    #############################################################################
    # Overriding Spree Controllers
    ApplicationController.class_eval do
      include MultiSiteSystem
      def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
      end
    end
    
    Spree::BaseController.class_eval do
      before_filter :get_site_and_products
      
      layout :get_layout
      
      def get_layout
        @site.layout.empty? ? "application" : @site.layout
      end

      def find_order      
        unless session[:order_id].blank?
          @order = Order.find_or_create_by_id(session[:order_id])
        else      
          @order = Order.create
        end
        @order.site = @site
        session[:order_id] = @order.id
        @order
      end
    end

    Admin::TaxonomiesController.class_eval do
      before_filter :load_data
      private
      def load_data
        @sites = Site.find(:all, :order=>"name")  
      end
    end

    Admin::ProductsController.class_eval do
      before_filter :load_data
      private
      def load_data
        @sites = @site.self_and_children
        @tax_categories = TaxCategory.find(:all, :order=>"name")  
        @shipping_categories = ShippingCategory.find(:all, :order=>"name")  
      end
      
      def collection
        @name = params[:name] || ""
        @sku = params[:sku] || ""
        @deleted =  (params.key?(:deleted)  && params[:deleted] == "on") ? "checked" : ""

        if @sku.blank?
          if @deleted.blank?
            @collection ||= end_of_association_chain.by_site_with_children(@site).active.by_name(@name).find(:all, :order => :name, :page => {:start => 1, :size => Spree::Config[:admin_products_per_page], :current => params[:p]})
          else
            @collection ||= end_of_association_chain.by_site_with_children(@site).deleted.by_name(@name).find(:all, :order => :name, :page => {:start => 1, :size => Spree::Config[:admin_products_per_page], :current => params[:p]})  
          end
        else
          if @deleted.blank?
            @collection ||= end_of_association_chain.by_site_with_children(@site).active.by_name(@name).by_sku(@sku).find(:all, :order => :name, :page => {:start => 1, :size => Spree::Config[:admin_products_per_page], :current => params[:p]})
          else
            @collection ||= end_of_association_chain.by_site_with_children(@site).deleted.by_name(@name).by_sku(@sku).find(:all, :order => :name, :page => {:start => 1, :size => Spree::Config[:admin_products_per_page], :current => params[:p]})
          end
        end
      end  
    end
  
    ProductsController.class_eval do    
      private
      def collection
        if params[:taxon]
          @taxon = Taxon.find(params[:taxon])

          @collection ||= Product.by_site(@site).active.find(
            :all, 
            :conditions => ["products.id in (select product_id from products_taxons where taxon_id in (" +  @taxon.descendents.inject( @taxon.id.to_s) { |clause, t| clause += ', ' + t.id.to_s} + "))" ], 
            :page => {:start => 1, :size => Spree::Config[:products_per_page], :current => params[:p]}, 
            :include => :images)
        else
          @collection ||= Product.by_site(@site).active.find(:all, :page => {:start => 1, :size => Spree::Config[:products_per_page], :current => params[:p]}, :include => :images)
        end
      end
    end
    
    TaxonsController.class_eval do
      private
      def load_data
        @products ||= object.products.by_site(@site).active.find(:all, :page => {:start => 1, :size => Spree::Config[:products_per_page], :current => params[:p]}, :include => :images)
        @product_cols = 3
      end
    end
    #############################################################################
    
    
    #############################################################################
    # Overriding Spree Helpers
    TaxonsHelper.class_eval do
      def taxon_preview(taxon)
        products = taxon.products.by_site(@site).active[0..4]
        return products unless products.size < 5
        if Spree::Config[:show_descendents]
          taxon.descendents.each do |taxon|
            products += taxon.products.by_site(@site).active[0..4]
            break if products.size >= 5
          end
        end
        products[0..4]
      end
    end
    #############################################################################
  end
end