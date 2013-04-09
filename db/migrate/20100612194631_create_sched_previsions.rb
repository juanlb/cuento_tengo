class CreateSchedPrevisions < ActiveRecord::Migration
  def self.up
    create_table :sched_previsions do |t|
      t.string :description
      t.integer :account_id
      t.integer :user_id
      t.float :amount
      t.integer :operation
      t.integer :category_id
      t.integer :last_apply_month
      t.integer :apply_day

      t.timestamps
    end
  end

  def self.down
    drop_table :sched_previsions
  end
end
