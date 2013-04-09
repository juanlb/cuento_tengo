class SchedPrevisionsController < ApplicationController

  # GET /moves
  # GET /moves.xml

  before_filter :login_required

  before_filter :levantar_datos

  def index
    set_back("/sched_previsions")
    @sched_prevision = SchedPrevision.new

    levantar_datos_index

  end


  # GET /sched_previsions/1/edit
  def edit
    @sched_prevision = SchedPrevision.find(params[:id])
  end

  # POST /sched_previsions
  # POST /sched_previsions.xml
  def create
    @sched_prevision = SchedPrevision.new(params[:sched_prevision])

    @sched_prevision.user_id = current_user.id

    if params[:operation] == "out"
      @sched_prevision.operation = -1
    else
      @sched_prevision.operation = 1
    end

    
    if @sched_prevision.save
      flash[:notice] = 'Se cre&oacute; la previsi&oacute;n con &eacute;xito'
      redirect_to(:action => 'index')
    else
      levantar_datos_index
      render :action => 'index'
    end
    
    
  end

  # PUT /sched_previsions/1
  # PUT /sched_previsions/1.xml
  def update
    @sched_prevision = SchedPrevision.find(params[:id])

    if params[:operation] == "out"
      @sched_prevision.operation = -1
    else
      @sched_prevision.operation = 1
    end

    
    if @sched_prevision.update_attributes(params[:sched_prevision])
      flash[:notice] = 'La previsi&oacute;n se modific&oacute; con &eacute;xito.'
      redirect_back_or_default({:controller => "sched_previsions"})
    else
      render :action => "edit"
    end
    
  end

  # DELETE /sched_previsions/1
  # DELETE /sched_previsions/1.xml
  def destroy
    @sched_prevision = SchedPrevision.find(params[:id])
    @sched_prevision.destroy

    flash[:notice] = 'Se elimin&oacute; la previsi&oacute;n con &eacute;xito'

    redirect_back_or_default({:controller => "sched_previsions"})
  end
  #=================================
  private
  def levantar_datos
    @accounts = current_user.accounts
    @categories = Category.all_categories(current_user)
    @num_day = []
    28.times do |i|
      @num_day << i + 1
    end

  end

  def levantar_datos_index
    
    @sched_previsions = current_user.sched_previsions
    @create_form  = 'create_sched_prevision_form'
    


  end


end
