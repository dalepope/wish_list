class CreateDrawnNameHistories < ActiveRecord::Migration
  def self.up
    create_table :drawn_name_histories do |t|
      t.integer :year
      t.integer :giver_id
      t.integer :receiver_id

      t.timestamps
    end
    add_index :drawn_name_histories, :year
    add_index :drawn_name_histories, :giver_id
    add_index :drawn_name_histories, :receiver_id
    add_index :drawn_name_histories, [:year, :giver_id], :unique => true
    add_index :drawn_name_histories, [:year, :receiver_id], :unique => true
  end

  def self.down
    drop_table :drawn_name_histories
  end
end
