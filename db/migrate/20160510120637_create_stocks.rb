class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :ticker, null: false
      t.string :name, null: false
      t.decimal :price
      t.date :pricing_date
      t.decimal :return
      t.decimal :risk
      t.decimal :sharpe
      t.decimal :alpha

      t.timestamps null: false
    end
  end
end
