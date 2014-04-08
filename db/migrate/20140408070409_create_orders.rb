class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :name
      t.text :phone
      t.text :email
      t.text :content
      
      t.timestamps
    end
  end
end
