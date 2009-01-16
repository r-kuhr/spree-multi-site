class AddSiteProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :site_id, :integer
  end

  def self.down
    remove_column :products, :site_id
  end
end