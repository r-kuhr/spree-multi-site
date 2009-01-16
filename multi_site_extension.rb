# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class MultiSiteExtension < Spree::Extension
  version "1.0"
  description "Extention that will allow the store to support multiple sites each having their own taxonomies, products and orders"
  url "git://github.com/tunagami/spree-multi-site.git"

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate
    # admin.tabs.add "Multi Site", "/admin/multi_site", :after => "Layouts", :visibility => [:all]
    Taxonomy.class_eval do
      belongs_to :site
    end

    Product.class_eval do
      belongs_to :site
    end

    ApplicationController.class_eval do
      include MultiSiteSystem
      def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
      end
    end

    ProductsController.class_eval do    
      before_filter :get_site_and_products
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
        @sites = Site.find(:all, :order=>"name")
        @tax_categories = TaxCategory.find(:all, :order=>"name")  
        @shipping_categories = ShippingCategory.find(:all, :order=>"name")  
      end
    end

  end
end