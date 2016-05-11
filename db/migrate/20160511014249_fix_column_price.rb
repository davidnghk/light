class FixColumnPrice < ActiveRecord::Migration
  def change
  	rename_column :stocks, :trade_price, :last_price
  end
end