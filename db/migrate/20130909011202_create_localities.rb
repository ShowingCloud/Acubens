class CreateLocalities < ActiveRecord::Migration
	def change
		create_table :localities do |t|

			t.string :name, :null => false
			t.integer :level, :null => false
			t.integer :parent, :null => false
			t.integer :sort, :default => 0

			t.integer :areacode
			t.integer :zipcode
			t.integer :telcode

			t.decimal :freight_paid, :precision => 5, :scale => 2, :default => 0
			t.decimal :freight_cod, :precision => 5, :scale => 2, :default => 0

			t.timestamps
		end
	end
end
