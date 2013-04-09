class Prevision < ActiveRecord::Base

  belongs_to :account
  belongs_to :user
  belongs_to :category

  validates_numericality_of :amount

  validates_presence_of :amount
  validates_presence_of :category_id
  validates_presence_of :account_id
  validates_presence_of :description



  def confirm
    Move.new(:description => self.description, :account_id => self.account_id, :user_id => self.user_id, :amount => self.amount, :operation => self.operation, :category_id => self.category_id, :created_at => self.created_at).save
    self.destroy
  end

  def self.posicion(user_id)
    prevs = Prevision.find(:first, :select => "sum(amount * operation) as total", :group => "user_id", :conditions => ["user_id = ?", user_id])
    if prevs.nil?
      format("%.2f\n",0)
    else
      format("%.2f\n", prevs.total.to_f)
    end
  end



  def amount=(monto)
    monto.to_s.gsub!(',','.')

    write_attribute(:amount, monto)
  rescue
    write_attribute(:amount, '')
  end
end
