class AddInDrawToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :in_draw, :boolean, :default => false
  end

  def self.down
    remove_column :users, :in_draw
  end
end
