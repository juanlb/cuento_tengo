class Currency < ActiveRecord::Base
  has_many :accounts
  has_many :users



  def value=(monto)
    monto.to_s.gsub!(',','.')

    write_attribute(:value, monto)
  rescue
    write_attribute(:value, '')
  end

end
