class AddFreightColumnsForLocalities < ActiveRecord::Migration
	def up
		add_column :localities, :freight_paid, :decimal, :precision => 5, :scale => 2, :default => 0
		add_column :localities, :freight_cod, :decimal, :precision => 5, :scale => 2, :default => 0
	end

	def down
		remove_column :localities, :freight_paid
		remove_column :localities, :freight_cod
	end
end
