class DonationsController < ApplicationController
  layout nil
  # GET /donations
  # GET /donations.json
  def index
    @donations = Donation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @donations }
    end
  end

   #GET /donations/1
   #GET /donations/1.json
  def show
    @donation = Donation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @donation }
    end
  end

  # GET /donations/new
  # GET /donations/new.json
  def new
    @donation = Donation.new
    @donationID = "new"
    #@selectedShow = Show.on_now

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.json { render json: @donation }
    end
  end

  # GET /donations/1/edit
  def edit
    @donation = Donation.find(params[:id])
    @donationID = params[:id]
    @selectedShow = @donation.show.id

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # POST /donations
  # POST /donations.json
  def create
    pledgerID = params[:donation].delete(:pledger_id)
    pledger = Pledger.find(pledgerID)
    @donation = pledger.donations.create(params[:donation])
    @activeDonations = pledger.donations.where("payment_received = 'false'")
    @archivedDonations = pledger.donations.where("payment_received = 'true'")

    respond_to do |format|
      if @donation.save
        format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
        format.json { render json: @donation, status: :created, location: @donation }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /donations/1
  # PUT /donations/1.json
  def update
    @donation = Donation.find(params[:id])
    respond_to do |format|
      if @donation.update_attributes(params[:donation])
        @activeDonations = @donation.pledger.donations.where("payment_received = 'false'")
        @archivedDonations = @donation.pledger.donations.where("payment_received = 'true'")
        format.html { redirect_to @donation.pledger, notice: 'Donation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    @donation = Donation.find(params[:id])
    pledger = @donation.pledger
    @donation.destroy

    respond_to do |format|
      format.html { redirect_to pledger_url(pledger) }
      format.json { head :no_content }
    end
  end
end
