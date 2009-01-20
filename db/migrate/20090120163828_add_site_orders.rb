class AddSiteOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :site_id, :integer
  end

  def self.down
    remove_column :orders, :site_id
  end
end