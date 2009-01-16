class Site < ActiveRecord::Base
  has_many :taxonomies
  has_many :products
  validates_presence_of   :name, :domain
end
