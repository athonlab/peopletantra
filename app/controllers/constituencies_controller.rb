class ConstituenciesController < ApplicationController
  # GET /constituencies
  # GET /constituencies.xml
  def index
    @constituencies = Constituency.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @constituencies }
    end
  end

  # GET /constituencies/1
  # GET /constituencies/1.xml
  def show
    @constituency = Constituency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @constituency }
    end
  end

  # GET /constituencies/new
  # GET /constituencies/new.xml
  def new
    @constituency = Constituency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @constituency }
    end
  end

  # GET /constituencies/1/edit
  def edit
    @constituency = Constituency.find(params[:id])
  end

  # POST /constituencies
  # POST /constituencies.xml
  def create
    @constituency = Constituency.new(params[:constituency])

    respond_to do |format|
      if @constituency.save
        flash[:notice] = 'Constituency was successfully created.'
        format.html { redirect_to(@constituency) }
        format.xml  { render :xml => @constituency, :status => :created, :location => @constituency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @constituency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /constituencies/1
  # PUT /constituencies/1.xml
  def update
    @constituency = Constituency.find(params[:id])

    respond_to do |format|
      if @constituency.update_attributes(params[:constituency])
        flash[:notice] = 'Constituency was successfully updated.'
        format.html { redirect_to(@constituency) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @constituency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /constituencies/1
  # DELETE /constituencies/1.xml
  def destroy
    @constituency = Constituency.find(params[:id])
    @constituency.destroy

    respond_to do |format|
      format.html { redirect_to(constituencies_url) }
      format.xml  { head :ok }
    end
  end
end
