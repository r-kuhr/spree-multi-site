class Site < ActiveRecord::Base
  has_many :taxonomies
  has_many :products
  has_many :orders
  validates_presence_of   :name, :domain
end
