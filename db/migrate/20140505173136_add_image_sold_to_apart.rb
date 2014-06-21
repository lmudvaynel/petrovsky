class AddImageSoldToApart < ActiveRecord::Migration
  def change
    add_column :apartments, :image_sold, :string
  end
end
