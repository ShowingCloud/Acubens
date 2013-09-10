require 'csv'

class SkinSurvey < ActiveRecord::Base
  attr_accessible :age, :brands, :care, :cost, :effects, :factors, :importance, :infos, :markets, :offline, :problems, :procedures, :shortcomings, :source, :style, :time, :user, :ways


  def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
		  csv << column_names
		  all.each do |item|
			  csv << item.attributes.values_at(*column_names)
		  end
	  end
  end
end
