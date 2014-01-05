class PledgersController < ApplicationController
  layout "pledgers"

  before_filter :authenticate_user!

  # GET /pledgers
  # GET /pledgers.json
  def index
    @pledgers = Pledger.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pledgers }
    end
  end

  # GET /pledgers/search.json?name=name
  def search
    @pledgers = Pledger.select_with_args("id, name, perm_address, similarity(name, ?) AS sml", params[:name]).where("name % ?", params[:name]).order("sml DESC,name")
    respond_to do |format|
      format.json { render json: @pledgers }
    end
  end

  # GET /pledgers/1
  # GET /pledgers/1.json
  def show
    @pledger = Pledger.find(params[:id])

    @activeDonations = @pledger.donations.where("payment_received = 'f'").includes(slot: [:show, :semester])
    @archivedDonations = @pledger.donations.where("payment_received = 't'").includes(slot: [:show, :semester])
    @activeRewards = @pledger.rewards.where("premia_sent = 'f'").includes(:item)
    @archivedRewards = @pledger.rewards.where("premia_sent = 't'").includes(:item)
    @activeComments = @pledger.comments.includes(:show).sort_by{|c| c.created_at}.reverse

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pledger }
    end
  end

  # GET /pledgers/new
  # GET /pledgers/new.json
  def new
    @pledger = Pledger.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pledger }
    end
  end

  # GET /pledgers/1/edit
  def edit
    @pledger = Pledger.find(params[:id])
  end

  # POST /pledgers
  # POST /pledgers.json
  def create
    @pledger = Pledger.new(params[:pledger])

    respond_to do |format|
      if @pledger.save
        format.html { redirect_to @pledger, notice: 'Pledger was successfully created.' }
        format.json { render json: @pledger, status: :created, location: @pledger }
      else
        format.html { render action: "new" }
        format.json { render json: @pledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pledgers/1
  # PUT /pledgers/1.json
  def update
    @pledger = Pledger.find(params[:id])

    respond_to do |format|
      if @pledger.update_attributes(params[:pledger])
        format.html { redirect_to @pledger, notice: 'Pledger was successfully updated.' }
        format.json { respond_with_bip(@pledger) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@pledger) }
      end
    end
  end

  # DELETE /pledgers/1
  # DELETE /pledgers/1.json
  def destroy
    @pledger = Pledger.find(params[:id])
    @pledger.destroy

    respond_to do |format|
      format.html { redirect_to pledgers_url }
      format.json { head :no_content }
    end
  end
end
