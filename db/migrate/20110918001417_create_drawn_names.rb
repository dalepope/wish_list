class CreateDrawnNames < ActiveRecord::Migration
  def self.up
    create_table :drawn_names do |t|
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :drawn_names, :giver_id, :unique => true
    add_index :drawn_names, :receiver_id, :unique => true
  end

  def self.down
    drop_table :drawn_names
  end
end
