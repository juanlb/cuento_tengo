# To change this template, choose Tools | Templates
# and open the template in the editor.

class CTFunctions
  def self.get_date_since_mes_actual
    mes = DateTime.strptime("28-#{Time.now.month}-#{Time.now.year}", "%d-%m-%Y").beginning_of_month +  35
    val = mes.beginning_of_month
    cond = " AND (created_at < ?)  "
    return cond, [val]
  end

  def self.get_date_since(month, year)
    mes = DateTime.strptime("28-#{month}-#{year}", "%d-%m-%Y") +  25
    val = mes.beginning_of_month
    val1 = (mes.beginning_of_month - 1).beginning_of_month
    cond = "AND (created_at < ? AND created_at > ?)  "

    return cond, [val, val1]
  end

  def self.gastos_categoria(current_user, cond, val, cuentas_seleccionadas, categorias_seleccionadas)
    gastos_categoria_cuenta = []
    current_user.accounts.each do |acc|
      gastos_categoria_cuenta << acc.gasto_por_categoria(cond, val, cuentas_seleccionadas, categorias_seleccionadas  )
    end

    gastos_categoria = {}
    gastos_categoria_cuenta.each do |gcc|
      gcc.each do |gc|
        if gastos_categoria[gc.category_id].nil?
          gastos_categoria[gc.category_id] = {:name => gc.category.name, :total => gc.total.to_f}
        else
          gastos_categoria[gc.category_id][:total] += gc.total.to_f
        end
      end
    end

    gastos_categoria_full = {}
    Category.all_parents(current_user).each do |cate|
      cat = cate.id
      if not gastos_categoria[cat].nil?
        gastos_categoria_full[cat] = {:name => gastos_categoria[cat][:name], :total => gastos_categoria[cat][:total]}
        gastos_categoria_full[cat][:details] = []
        gastos_categoria_full[cat][:details] << {:name => gastos_categoria[cat][:name], :monto => gastos_categoria[cat][:total]}
      else
        gastos_categoria_full[cat] = {:name => cate.name, :total => 0.0}
        gastos_categoria_full[cat][:details] = []
      end
      Category.find(cat).children_categories.each do |chil|
        if not gastos_categoria[chil.id].nil?
          gastos_categoria_full[cat][:total] += gastos_categoria[chil.id][:total]
          gastos_categoria_full[cat][:details] << {:name => gastos_categoria[chil.id][:name], :monto => gastos_categoria[chil.id][:total]}
        end
      end

      #Normalizo los datos: todos lo valores estan negativos y ordeno el array de mayor a menor
      gastos_categoria_full[cat][:total] *= -1
      gastos_categoria_full[cat][:total] = gastos_categoria_full[cat][:total].to_f.round(2)
      gastos_categoria_full[cat][:details].each do |det|
        det[:monto] = det[:monto].to_f.round(2)
        det[:monto] *= -1
      end
      gastos_categoria_full[cat][:details].sort! { |a,b| b[:monto] <=> a[:monto] }
    end
    gastos_categoria_full

  end

end
