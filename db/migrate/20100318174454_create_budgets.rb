class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.float :amount
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
