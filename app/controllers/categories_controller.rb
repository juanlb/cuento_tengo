class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml

  before_filter :login_required


  def index
    set_back("/categories")
    @categories = Category.all_parents(current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    @parent_categories  = Category.all_parents(current_user)

  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @parent_categories  = Category.all_parents(current_user)
  end

  def cancel
    redirect_back_or_default({:controller => "categories", :action => "index"})
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    @parent_categories  = Category.all_parents(current_user)
  
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_back_or_default({:controller => "categories", :action => "index"})
    else
      render :action => "new" 
    end
    
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        flash[:notice] = 'Category was successfully updated.'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to(categories_url) }
      format.xml  { head :ok }
    end
  end
end
