namespace :db do
  desc "Bootstrap your database for Spree."
  task :bootstrap  => :environment do
    # load initial database fixtures (in db/sample/*.yml) into the current environment's database
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    Dir.glob(File.join(MultiSiteExtension.root, "db", 'sample', '*.{yml,csv}')).each do |fixture_file|
      Fixtures.create_fixtures("#{MultiSiteExtension.root}/db/sample", File.basename(fixture_file, '.*'))
    end
    
    # Loading in all sample data into database.
    site = Site.create(:name => "local", :domain => "localhost", :layout => "localhost")
    site.products = Product.find(:all)
    site.taxonomies = Taxonomy.find(:all)
    site.orders = Order.find(:all)
    site.save
    
  end
end

namespace :spree do
  namespace :extensions do
    namespace :multi_site do
      desc "Copies public assets of the Multi Site to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[MultiSiteExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(MultiSiteExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end

namespace :spree do
  namespace :extensions do
    namespace :multi_site do
      desc "Copies public assets of the Multi Site to the instance public/ directory."
      task :bootstrap_multi_site => :environment do
        # Loading in all sample data into database.
        site = Site.create(:name => "local", :domain => "localhost", :layout => "localhost")
        site.products = Product.find(:all)
        site.taxonomies = Taxonomy.find(:all)
        site.orders = Order.find(:all)
        site.save
      end  
    end
  end
end