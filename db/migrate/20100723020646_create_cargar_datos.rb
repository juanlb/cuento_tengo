class CreateCargarDatos < ActiveRecord::Migration
  def self.up
    DataLoader.load_data
  end

  def self.down
    DataLoader.destroy_data
  end
end
