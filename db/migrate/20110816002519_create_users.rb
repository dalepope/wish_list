class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.boolean :admin, :default => false

      t.timestamps
    end
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
