class AddShowPriceToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :show_price, :boolean, :default => false
  end
end
