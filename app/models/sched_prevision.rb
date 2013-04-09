class SchedPrevision < ActiveRecord::Base

  belongs_to :account
  belongs_to :user
  belongs_to :category

  validates_numericality_of :amount

  validates_presence_of :amount
  validates_presence_of :category_id
  validates_presence_of :account_id
  validates_presence_of :description


  def crear_prevision(mes)
    if (self.last_apply_month.nil?) or (self.last_apply_month != mes)
      ahora = Time.now
      #Crear previsión
      prev = Prevision.new(:description => self.description, :account_id => self.account_id, :user_id => self.user_id, :amount => self.amount, :operation => self.operation, :category_id => self.category_id)
      prev.created_at =  DateTime.new(y=ahora.year, m=ahora.month,d=self.apply_day, h=0,min=0,s=0)
      prev.save

      #Actualizar prevision programada
      self.last_apply_month = mes
      self.save
    end
  end


  def amount=(monto)
    monto.to_s.gsub!(',','.')

    write_attribute(:amount, monto)
  rescue
    write_attribute(:amount, '')
  end


end
