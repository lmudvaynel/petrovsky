class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.boolean :showed

      t.timestamps
    end
  end
end
