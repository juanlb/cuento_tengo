# To change this template, choose Tools | Templates
# and open the template in the editor.

class DataLoader
  def self.load_data

    u = User.new(:login => "admin", :email => "admin@dodgit.com", :password => "admin", :password_confirmation => "admin")
    u.save

    Currency.new(:name => "pesos", :value => 0.262041).save
    Currency.new(:name => "dolares", :value => 1).save
    Currency.new(:name => "euros", :value => 1.4032).save

    c0 = Category.new(:name => "Transferencia")
    c0.save

    c1 = Category.new(:name => "Casa", :user_id => u.id)
    c1.save
    c2 = Category.new(:name => "Alquiler", :user_id => u.id)
    c2.parent_category_id = c1.id
    c2.save
  end

  def self.destroy_data

  end
end
