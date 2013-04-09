# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  include AuthenticatedSystem

  def set_back(path = nil)
    #Guarda el punto actual para despues usar 'redirect_back_or_default'
    if path.nil?
      session[:return_to] = "/#{params[:controller]}/#{params[:action]}"
    else
      session[:return_to] = path
    end
  end


  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def select_array_months
    meses = [[1,'Enero'],[2,'Febrero'],[3,'Marzo'],[4,'Abril'],[5,'Mayo'],[6,'Junio'],[7,'Julio'],[8,'Agosto'],[9,'Septiembre'],[10,'Ocubre'],[11,'Noviembre'],[12,'Diciembre']]
    ret = ''
    meses.each do |m|
      ret += "<option value='#{m[0]}' #{session[:date_month].to_s == m[0].to_s ? 'selected=selected' : ''}>#{m[1]}</option>"
    end
    ret
  end

  def select_array_years
    anio = Time.now.year
    ret = ''
    10.times do
      ret += "<option value='#{anio}'  #{session[:date_year].to_s == anio.to_s ? 'selected=selected' : ''}>#{anio}</option>"
      anio -= 1
    end
    ret
  end

  def cuentas_seleccionadas
    arr_accounts = []
    @accounts.each do |acc|
      if !session["account_#{acc.id}"].nil?
        if session["account_#{acc.id}"] == 1
          arr_accounts << "account_id = #{acc.id}"
        end
      end
    end

    cond_accounts = arr_accounts.join(" OR ")
    cond_accounts = "(#{cond_accounts}) AND " unless cond_accounts.blank?

    cond_accounts
  end


  def categorias_seleccionadas
    arr_categories = []
    @categories.each do |cat|
      if !session["category_#{cat.id}"].nil?
        if session["category_#{cat.id}"] == 1
          arr_categories << "category_id = #{cat.id}"
        end
      end
    end

    cond_categories = arr_categories.join(" OR ")
    cond_categories = "(#{cond_categories}) AND " unless cond_categories.blank?

    cond_categories
  end


  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
