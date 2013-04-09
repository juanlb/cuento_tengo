class Move < ActiveRecord::Base

  belongs_to :account
  belongs_to :user
  belongs_to :category
  has_one :feemove, :dependent => :destroy
  
  validates_numericality_of :amount
  validates_presence_of :amount
  validates_presence_of :category_id
  validates_presence_of :account_id
  validates_presence_of :description


  def amount=(monto)
    monto.to_s.gsub!(',','.')

    write_attribute(:amount, monto)
  rescue
    write_attribute(:amount, '')
  end


end
