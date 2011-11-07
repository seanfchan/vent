class CreateVotevents < ActiveRecord::Migration
  def self.up
    create_table :votevents do |t|
      t.integer :ventpost_id
      t.integer :user_id

      t.timestamps
    end

    add_index :votevents, :ventpost_id
    add_index :votevents, :user_id
  end

  def self.down
    drop_table :votevents
  end
end
