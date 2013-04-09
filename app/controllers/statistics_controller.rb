class StatisticsController < ApplicationController
  before_filter :login_required
  before_filter :levantar_datos

  def index
    levantar_datos_index
  end

def setear_sesion_statistics
    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)

    @accounts.each do |acc|
      if params["account_#{acc.id}"].nil?
        session["account_#{acc.id}"] = 0
      else
        session["account_#{acc.id}"] = 1
      end
    end

    @categories.each do |cat|
      if params["category_#{cat.id}"].nil?
        session["category_#{cat.id}"] = 0
      else
        session["category_#{cat.id}"] = 1
      end
    end

    session[:date_year] = params[:date_year]
    session[:date_month] = params[:date_month]

    levantar_datos

    redirect_to :action => "index"
  end

  private

  def levantar_datos
    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)
    @categories_parents = Category.all_parents(current_user)


    @side_con_form = true
    @side_con_form_action = "setear_sesion_statistics"

    @select_array_years = select_array_years
    @select_array_months = select_array_months
  end

  def levantar_datos_index
    require "c_t_functions"

    cond, val = CTFunctions::get_date_since(session[:date_month],session[:date_year])
    @gastos_categoria_full = CTFunctions::gastos_categoria(current_user, cond, val, cuentas_seleccionadas, categorias_seleccionadas  )
  end

end