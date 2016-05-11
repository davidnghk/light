class AddNoofpricesToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :no_of_prices, :int
  end
end
