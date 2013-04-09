class MovesController < ApplicationController

  # GET /moves
  # GET /moves.xml

  before_filter :verificar_sched_prevision

  before_filter :login_required, :except => [:init]

  before_filter :levantar_datos, :except => [:init]

  #interface para el celu
  def  m
    set_back("/moves/m")

    @move = Move.new
    @move.created_at = Time.now

    render :layout => false
  end

  def init
    
  end

  #Atiende el post del formulario de seleccion de cuentas y categorias
  #Segun los valores que llegan, crea o setea las variables de sesion guardando lo que desea ver el usuario
  def setear_sesion
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


  def setear_sesion_position
    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)

    @accounts.each do |acc|
      if params["account_#{acc.id}"].nil?
        session["account_#{acc.id}"] = 0
      else
        session["account_#{acc.id}"] = 1
      end
    end

    levantar_datos

    redirect_to :action => "position"

  end



  def edit_currency
    @currencies = Currency.all
    @user = current_user
  end

  def select_currency
    user = User.find(params[:id])
    user.currency_id = (params[:user])[:currency_id]
    user.save

    flash[:notice] = "Se seleccion&oacute; una nueva moneda"

    redirect_to :controller => "moves", :action => "index"
  end

  def transfer
    set_back
    levantar_datos_transfer
    render :action => "index"
  end

  def ajuste
    @move = Move.new
    @move.created_at = Time.now
    set_back
    levantar_datos_ajuste
    render :action => "index"
  end

  def create_transfer
    if (params[:created_at].blank?) or (params[:orig_account_id] == '0') or (params[:dest_account_id] == '0') or ((params[:change].blank?) or (params[:change] == 0)) or (params[:amount].blank?)
      @error = "error"
    else
      @error = "OK"
    end

    transf_value = params[:amount].to_f / params[:change].to_f

    @trans = Move.new(:created_at => params[:created_at], :description => params[:description].to_s, :account_id => params[:orig_account_id], :user_id => current_user.id, :amount => params[:amount], :operation => -1, :category_id => 1)
    if @trans.save
      Move.new(:created_at => params[:created_at], :description => params[:description].to_s, :account_id => params[:dest_account_id], :user_id => current_user.id, :amount => transf_value, :operation => 1, :category_id => 1).save
      redirect_to :action => "transfer"
    else
      levantar_datos_transfer
      render :action => 'index'
    end
  end

  def create_ajuste

    nuevo_saldo = params[:move][:amount].to_f
    saldo = Account.find(params[:move][:account_id]).saldo.to_f

    if nuevo_saldo == saldo
      @move = Move.new(params[:move])
      flash[:notice] = "No hay modificacion en el monto"
      levantar_datos_ajuste
      render :action => 'index'
    else

      @move = Move.new(params[:move])
      @move.user_id = current_user.id



      if nuevo_saldo < saldo
        @move.operation = -1
        @move.amount = saldo - nuevo_saldo
      else
        @move.operation = 1
        @move.amount = nuevo_saldo - saldo
      end

      

      if @move.save
        flash[:notice] = "Se cre&oacute; el ajuste"
        redirect_to :action => "ajuste"
      else
        levantar_datos_ajuste
        render :action => 'index'
      end

    end
  end

  def dest_acounts
    @accounts_m = @accounts.reject { |item| (item.id.to_s == params[:id]) or (params[:id] == '0')  }
    render :layout => false
  end

  def account_saldo
    @account_saldo = Account.find(params[:id]).saldo.to_f
    render :layout => false
  end

  def set_change
    orig_acc = Account.find(params[:orig_id])
    dest_acc = Account.find(params[:dest_id])

    @misma_moneda = orig_acc.currency_id == dest_acc.currency_id

    if !@misma_moneda
      if orig_acc.currency_id == current_user.currency_id
        @change = dest_acc.currency.value / orig_acc.currency.value
      elsif dest_acc.currency_id == current_user.currency_id
        @change = orig_acc.currency.value / dest_acc.currency.value
      else
        @change = dest_acc.currency.value / orig_acc.currency.value
      end


      #@change = dest_acc.currency.value / orig_acc.currency.value
      @change = format("%.2f\n",@change)
    else
      @change = 1
    end

    render :layout => false
  end
  
  def index
    set_back("/moves")

    levantar_datos_index

    @move = Move.new
    @move.created_at = Time.now
  end

  def show
    @move = Move.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @move }
    end
  end



  def new
    @move = Move.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @move }
    end
  end

  # GET /moves/1/edit
  def edit
    @move = Move.find(params[:id])
    @transferencia = (@move.category_id == 1)
  end


  def create_m

    @move = Move.new(params[:move])
    @move.user_id = current_user.id

    if params[:operation] == "out"
      @move.operation = -1
    else
      @move.operation = 1
    end

    if @move.save
      flash[:notice] = "Se cre&oacute; el movimiento"
      redirect_to :action => "m"

    else
      flash[:notice] = "ERROR! Revise los datos"
      @error = true
      render :action => 'm', :layout => false
    end
  end


  def create
    
    @move = Move.new(params[:move])
    @move.user_id = current_user.id

    if params[:operation] == "out"
      @move.operation = -1
    else
      @move.operation = 1
    end
    
    if @move.save
      flash[:notice] = "Se cre&oacute; el movimiento"
      redirect_to :action => "index"
    else
      levantar_datos_index
      render :action => 'index'
    end

  end

  # PUT /moves/1
  # PUT /moves/1.xml
  def update
    @move = Move.find(params[:id])

    if params[:operation] == "out"
      @move.operation = -1
    else
      @move.operation = 1
    end

    if @move.update_attributes(params[:move])
      flash[:notice] = 'El movimiento se modific&oacute; con &eacute;xito.'
      redirect_back_or_default({:controller => "moves"})
    else
      render :action => "edit" 
    end
    
  end

  # DELETE /moves/1
  # DELETE /moves/1.xml
  def destroy
    @move = Move.find(params[:id])
    @move.destroy

    flash[:notice] = "Se elimin&oacute; el movimiento con &eacute;"

    redirect_back_or_default({:controller => "moves", :action => "index"})
  end


  #=============== Posiciones

  def position

    cond, val = CTFunctions::get_date_since_mes_actual
    previsiones = Prevision.find(:all, :conditions => ["user_id = ? AND category_id <> ? " + cond, current_user.id, 1] + val, :order => "created_at ASC")
    @prevs_periodo = 0
    previsiones.each do |p|
      @prevs_periodo += (p.amount * p.operation)
    end
  end
  
  #=============== Previsiones


  def prevision
    set_back
    levantar_datos_prev
    @prev = Prevision.new
    @prev.created_at = Time.now
    render :action => "index"
  end

  def confirm_prev
    prev = Prevision.find(params[:id])
    prev.confirm
    
    redirect_back_or_default({:controller => "moves", :action => "index"})
  end

  def edit_prev
    @prev = Prevision.find(params[:id])
  end

  def edit_confirm_prev
    @prev = Prevision.find(params[:id])
    @confirm_prev = true
    render :action => :edit_prev
  end

  def update_prev
    @prev = Prevision.find(params[:id])

    if params[:operation] == "out"
      @prev.operation = -1
    else
      @prev.operation = 1
    end
    if params[:confirm_prev] == "true"
      @confirm_prev = true
    end
    if @prev.update_attributes(params[:prev])
      mensaje = 'La previsi&oacute;n se modific&oacute; con &eacute;xito.'
      if @confirm_prev
        @prev.confirm
        mensaje = 'La previsi&oacute;n se modific&oacute; y se confirm&oacute; con &eacute;xito.'
      end
      flash[:notice] = mensaje

      redirect_back_or_default({:controller => "moves", :action => "index"})
    else
      render :action => "edit_prev"
    end

  end

  def create_prev

    @prev = Prevision.new(params[:prev])
    @prev.user_id = current_user.id

    if params[:operation] == "out"
      @prev.operation = -1
    else
      @prev.operation = 1
    end

    if @prev.save
      flash[:notice] = "Se cre&oacute; la previsi&oacute;n"
      redirect_to :action => "prevision"
    else
      levantar_datos_prev
      render :action => 'index'
    end

    

  end

  def destroy_prev
    @prev = Prevision.find(params[:id])
    @prev.destroy

    flash[:notice] = "Se elimin&oacute; la previsi&oacute; con &eacute;xito"

    redirect_back_or_default({:controller => "moves", :action => "index"})
  end
  #=================================
  private
  def levantar_datos
    session[:date_year] ||= Time.now.year.to_s
    session[:date_month] ||= Time.now.month.to_s

    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)

    @moves = moves
    @prevs = prevs

    @side_con_form = true
    @select_array_years = select_array_years
    @select_array_months = select_array_months
  end

  
  #Carga los movimientos que desea ver el usuario, usando las variables de sesion
  def moves
    require "c_t_functions"

    cond, val = CTFunctions::get_date_since(session[:date_month],session[:date_year])
    Move.find(:all, :conditions => [cuentas_seleccionadas + categorias_seleccionadas + "user_id = ? AND category_id <> ? " + cond, current_user.id, 1] + val, :order => "created_at DESC")
  end

  def prevs
    Prevision.find(:all, :conditions => ["user_id = ? AND category_id <> ?", current_user.id, 1], :order => "created_at ASC")
  end

  def verificar_sched_prevision
    if logged_in?
      if current_user.pasaron_horas?(1)
        ejectar_sched_prevision
      end
    end
  
  end

  def ejectar_sched_prevision
    mes = Time.now.month
    current_user.sched_previsions.each do |sched_prev|
      sched_prev.crear_prevision(mes)
    end
  end


  def levantar_datos_index
    @form_class = 'index'
    @show_prevs = true
    @create_form = "create_move_form"
  end
  
  def levantar_datos_transfer
    @side_con_form = false

    @form_class = 'transfer'
    @show_prevs = false
    @create_form = "create_transfer_form"
    @moves = Move.find(:all, :conditions => ["user_id = ? AND category_id = ?", current_user.id, 1], :order => "created_at DESC")
  end


  def levantar_datos_prev
    @form_class = 'prevision'
    @show_prevs = true
    @create_form = "create_prevision_form"
  end

  def levantar_datos_ajuste
    @form_class = 'ajuste'
    @show_prevs = false
    @create_form = "create_ajuste_form"
  end

end
