class CreateFeemoves < ActiveRecord::Migration
  def self.up
    create_table :feemoves do |t|
      t.integer :fee_id
      t.integer :move_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feemoves
  end
end
