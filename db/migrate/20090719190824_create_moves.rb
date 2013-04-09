class CreateMoves < ActiveRecord::Migration
  def self.up
    create_table :moves do |t|
      t.string :description
      t.integer :account_id
      t.integer :user_id
      t.float :amount
      t.integer :operation
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :moves
  end
end
