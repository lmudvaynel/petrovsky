class AddPriceAndSToApart < ActiveRecord::Migration
  def change
    add_column :apartments, :price, :string
    add_column :apartments, :area, :string
  end
end
