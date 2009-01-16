class AddSiteTaxonomies < ActiveRecord::Migration
  def self.up
    add_column :taxonomies, :site_id, :integer
  end

  def self.down
    remove_column :taxonomies, :site_id
  end
end