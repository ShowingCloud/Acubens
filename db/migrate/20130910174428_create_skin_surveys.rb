class CreateSkinSurveys < ActiveRecord::Migration
  def change
    create_table :skin_surveys do |t|
      t.string :user
      t.string :style
      t.string :care
      t.string :problems
      t.string :time
      t.string :procedures
      t.string :effects
      t.string :shortcomings
      t.string :cost
      t.string :markets
      t.string :factors
      t.string :brands
      t.string :importance
      t.string :source
      t.string :ways
      t.string :infos
      t.string :offline
      t.string :age

      t.timestamps
    end
  end
end
