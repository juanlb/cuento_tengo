class Account < ActiveRecord::Base

  belongs_to :user
  belongs_to :currency
  has_many :moves, :dependent => :destroy
  has_many :previsions, :dependent => :destroy
  has_many :sched_previsions, :dependent => :destroy
  has_many :fees, :dependent => :destroy

  validates_numericality_of :initial
  validates_presence_of :name


  def saldo

    require "c_t_functions"

    cond, val = CTFunctions::get_date_since_mes_actual
    
    moves = Move.find(:first, :select => "sum(amount * operation) as total", :group => "account_id", :conditions => ["account_id = ? " + cond, self.id] + val)
    if moves.nil?
      format("%.2f\n",self.initial)
    else
      format("%.2f\n",self.initial + moves.total.to_f)
    end
  end


  def gasto_por_categoria(cond, val, cuentas_seleccionadas, categorias_seleccionadas)
    Move.find(:all, :select => "account_id, category_id, sum(amount * operation) as total", :group => "account_id, category_id", :conditions => [cuentas_seleccionadas + categorias_seleccionadas + "account_id = ? and category_id <> ? " + cond, self.id, 1] + val)
  end

  def initial=(monto)
    monto.to_s.gsub!(',','.')

    write_attribute(:initial, monto)
  rescue
    write_attribute(:initial, '')
  end


end
