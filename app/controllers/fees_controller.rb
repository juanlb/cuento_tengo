class FeesController < ApplicationController

  before_filter :login_required

  before_filter :levantar_datos

  # GET /fees
  # GET /fees.xml
  def index
    set_back("/fees")
    @fee = Fee.new

    levantar_datos_index
  end

  # GET /fees/1/edit
  def show
    @fee = Fee.find(params[:id])
    set_back("/fees/#{@fee.id}")
  end

  # POST /fees
  # POST /fees.xml
  def create
    @fee = Fee.new(params[:fee])
    @fee.user_id = current_user.id

    if params[:operation] == "out"
      @fee.operation = -1
    else
      @fee.operation = 1
    end

    
    if @fee.save

      #creo los movimientos
      fecha = @fee.created_at.beginning_of_month + 9.days
      @fee.fee_cant.times do
        fecha
        m = Move.new( :created_at => fecha, :description => @fee.description, :account_id => @fee.account_id, :user_id => @fee.user_id, :amount => @fee.amount, :operation => @fee.operation, :category_id => @fee.category_id)
        m.save
        fm = Feemove.new(:fee_id => @fee.id, :move_id => m.id)
        fm.save
        fecha = (fecha + 30.days).beginning_of_month + 9.days
      end

      flash[:notice] = 'Se crearon las cuotas con &eacute;xito'
      redirect_to(:action => 'index')
    
    else
      levantar_datos_index
      render :action => "index"
    
    end
  
  end


  # DELETE /fees/1
  # DELETE /fees/1.xml
  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy
    flash[:notice] = 'Se eliminaron las cuotas con &eacute;xito'
    redirect_back_or_default({:controller => "fees"})
  end

  private
  def levantar_datos
    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)
    
  end

  def levantar_datos_index

    @fees = current_user.fees
    @create_form  = 'create_fee_form'

  end

end
