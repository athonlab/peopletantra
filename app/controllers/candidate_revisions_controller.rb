class CandidateRevisionsController < ApplicationController
  # GET /candidate_revisions
  # GET /candidate_revisions.xml
  def index
    @candidate_revisions = CandidateRevision.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @candidate_revisions }
    end
  end

  # GET /candidate_revisions/1
  # GET /candidate_revisions/1.xml
  def show
    @candidate_revision = CandidateRevision.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @candidate_revision }
    end
  end

  # GET /candidate_revisions/new
  # GET /candidate_revisions/new.xml
  def new
    @candidate_revision = CandidateRevision.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @candidate_revision }
    end
  end

  # GET /candidate_revisions/1/edit
  def edit
    @candidate_revision = CandidateRevision.find(params[:id])
  end

  # POST /candidate_revisions
  # POST /candidate_revisions.xml
  def create
    @candidate_revision = CandidateRevision.new(params[:candidate_revision])

    respond_to do |format|
      if @candidate_revision.save
        flash[:notice] = 'CandidateRevision was successfully created.'
        format.html { redirect_to(@candidate_revision) }
        format.xml  { render :xml => @candidate_revision, :status => :created, :location => @candidate_revision }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @candidate_revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /candidate_revisions/1
  # PUT /candidate_revisions/1.xml
  def update
    @candidate_revision = CandidateRevision.find(params[:id])

    respond_to do |format|
      if @candidate_revision.update_attributes(params[:candidate_revision])
        flash[:notice] = 'CandidateRevision was successfully updated.'
        format.html { redirect_to(@candidate_revision) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @candidate_revision.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_revisions/1
  # DELETE /candidate_revisions/1.xml
  def destroy
    @candidate_revision = CandidateRevision.find(params[:id])
    @candidate_revision.destroy

    respond_to do |format|
      format.html { redirect_to(candidate_revisions_url) }
      format.xml  { head :ok }
    end
  end
end
