class AddParentToStock < ActiveRecord::Migration
  def change
    add_reference :stocks, :parent, index: true
  end
end
