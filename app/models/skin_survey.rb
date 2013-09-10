class SkinSurvey < ActiveRecord::Base
  attr_accessible :age, :brands, :care, :cost, :effects, :factors, :importance, :infos, :markets, :offline, :problems, :procedures, :shortcomings, :source, :style, :time, :user, :ways
end
