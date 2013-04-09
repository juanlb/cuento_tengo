class BudgetsController < ApplicationController

  before_filter :login_required
  before_filter :levantar_datos

  # GET /budgets
  # GET /budgets.xml
  def index
    set_back
    levantar_datos_index
    
    @budget = Budget.new
  end

  # GET /budgets/1
  # GET /budgets/1.xml
  def show
    @budget = Budget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/new
  # GET /budgets/new.xml
  def new
    @budget = Budget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/1/edit
  def edit
    @budget = Budget.find(params[:id])
  end

  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])
    @budget.user_id = current_user.id


    if @budget.save
      flash[:notice] = 'Budget was successfully created.'
      redirect_to :action => "index"
    else
      levantar_datos_index
      render :action => "index"
    end

  end

  # PUT /budgets/1
  # PUT /budgets/1.xml
  def update
    @budget = Budget.find(params[:id])


    if @budget.update_attributes(params[:budget])
      flash[:notice] = 'Budget was successfully updated.'
      redirect_to({:controller => "budgets", :action => ''})
    else
      render :action => "edit"
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.xml
  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy

    respond_to do |format|
      format.html { redirect_to(budgets_url) }
      format.xml  { head :ok }
    end
  end

  def setear_sesion_budgets
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
    @categories_combo = Category.all_parents(current_user)

    @side_con_form = true
    @side_con_form_action = "setear_sesion_budgets"

    @select_array_years = select_array_years
    @select_array_months = select_array_months
  end

  def levantar_datos_index
    @form_class = 'budget'
    @budgets = current_user.budgets
    @create_form = "create_budget_form"


    cond, val = CTFunctions::get_date_since(session[:date_month],session[:date_year])
    @gastos_categoria_full = CTFunctions::gastos_categoria(current_user, cond, val, cuentas_seleccionadas, categorias_seleccionadas )

  end
  
end
