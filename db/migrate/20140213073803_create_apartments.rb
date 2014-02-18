class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.string :image
      t.integer :dx, null: false, default: 0
      t.integer :dy, null: false, default: 0
      t.integer :number
      t.integer :floor_number
      t.boolean :sold_out, null: false, default: false

      t.timestamps
    end
  end
end
