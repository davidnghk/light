class FixUkStockprice < ActiveRecord::Migration
  def change
  	add_index :stock_prices, [:stock_id, :trade_date], :unique => true
  end
end
