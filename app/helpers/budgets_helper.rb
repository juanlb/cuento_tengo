module BudgetsHelper
  def porcentaje(total, valor)
    if total == 0
      val = 0.0
    else
      val = ((valor.to_f * 100.0) / total.to_f).round(2)
    end
    
  end

  def show_porcentaje(porcentaje)
    if porcentaje > 100.0
      "<img src='/images/percents/11.png' />"
    elsif porcentaje < 0.0
      "<img src='/images/percents/0.png' />"
    else
      equis = (porcentaje / 10.0).round
      "<img src='/images/percents/#{equis.to_s}.png' />"
    end

  end
end
