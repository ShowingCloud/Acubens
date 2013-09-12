class Locality < ActiveRecord::Base
  attr_accessible :areacode, :freight_cod, :freight_paid, :level, :name, :parent, :sort, :telcode, :zipcode
end
