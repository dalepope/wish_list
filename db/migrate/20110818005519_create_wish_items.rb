class CreateWishItems < ActiveRecord::Migration
  def self.up
    create_table :wish_items do |t|
      t.text :description
      t.string :url
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
    add_index :wish_items, :user_id
  end

  def self.down
    drop_table :wish_items
  end
end
