class FixCOlumnPrice < ActiveRecord::Migration
  def change
  	rename_column :stocks, :price, :trade_price
  end
end
