class AddShortNameAndParentIdToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :parent_id, :integer
    add_column :sites, :short_name, :string
  end

  def self.down
    remove_column :sites, :parent_id
    remove_column :sites, :short_name
  end
end