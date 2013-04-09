class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.integer :user_id
      t.integer :account_id
      t.string :description
      t.float :amount
      t.integer :operation
      t.integer :category_id
      t.integer :fee_cant

      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
