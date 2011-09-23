class CreateDrawExclusions < ActiveRecord::Migration
  def self.up
    create_table :draw_exclusions do |t|
      t.integer :excluder_id
      t.integer :excluded_id

      t.timestamps
    end
    add_index :draw_exclusions, :excluder_id
    add_index :draw_exclusions, :excluded_id
    add_index :draw_exclusions, [:excluder_id, :excluded_id], :unique => true
  end

  def self.down
    drop_table :draw_exclusions
  end
end
