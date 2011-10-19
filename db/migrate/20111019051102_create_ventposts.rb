class CreateVentposts < ActiveRecord::Migration
  def self.up
    create_table :ventposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end

    add_index :ventposts, :user_id
  end

  def self.down
    drop_table :ventposts
  end
end
