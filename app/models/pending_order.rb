class PendingOrder < ActiveRecord::Base
  	attr_accessible :orderid, :points, :username

	validates :orderid, :presence => true, :uniqueness => true
	validates :points, :presence => true
	validates :username, :presence => true
end
