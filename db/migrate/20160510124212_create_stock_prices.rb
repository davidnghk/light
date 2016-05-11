class CreateStockPrices < ActiveRecord::Migration
  def change
    create_table :stock_prices do |t|
      t.date :trade_date, null: false
      t.decimal :open
      t.integer :volume
      t.decimal :high
      t.decimal :low
      t.decimal :close, null: false
      t.decimal :adj_close
      t.decimal :return
      t.references :stock, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
