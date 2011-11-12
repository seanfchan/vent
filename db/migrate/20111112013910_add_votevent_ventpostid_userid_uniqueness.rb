class AddVoteventVentpostidUseridUniqueness < ActiveRecord::Migration
  def self.up
    add_index :votevents, [:ventpost_id, :user_id], :unique => true
  end

  def self.down
    remove_index :votevents, :column => [:ventpost_id, :user_id]
  end
end
