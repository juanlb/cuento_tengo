class AddCurrencyIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :currency_id, :integer
  end

  def self.down
    remove_column :users, :currency_id
  end
end
