class AddMessageDescription < ActiveRecord::Migration
  def change
    add_column :messages, :description, :text
  end
end
