class CreateWishCategories < ActiveRecord::Migration
  def self.up
    create_table :wish_categories do |t|
      t.string :name

      t.timestamps
    end
    add_index :wish_categories, :name, :unique => true
  end

  def self.down
    drop_table :wish_categories
  end
end
