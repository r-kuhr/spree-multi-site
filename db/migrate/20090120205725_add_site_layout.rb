class AddSiteLayout < ActiveRecord::Migration
  def self.up
    add_column :sites, :layout, :string
  end

  def self.down
    remove_column :sites, :layout
  end
end