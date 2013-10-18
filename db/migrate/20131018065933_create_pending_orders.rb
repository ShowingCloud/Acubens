class CreatePendingOrders < ActiveRecord::Migration
  def change
    create_table :pending_orders do |t|
      t.string :orderid
      t.string :username
      t.integer :points

      t.timestamps
    end
  end
end
