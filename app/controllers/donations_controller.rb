class DonationsController < ApplicationController
  layout 'slots'

  before_action :authenticate_user!, except: :index

  # GET /donations
  # GET /donations.json
  def index
    semester = Semester.find_by month: params[:month], year: params[:year]
    semester ||= Semester.current_semester
    @semester = semester.decorate

    respond_to do |format|
      format.html do
        authenticate_user!
      end
      format.json do
        fresh_when last_modified: Donation.last.created_at, public: true
      end
      format.csv do
        authenticate_user!
        headers['Content-Disposition'] =
          "attachment; filename=\"#{@semester.name}_Donations.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end

  end

  def underwriting
    @underwriting = Donation.includes(:pledger).includes(slot: [:show])
      .select{ |d| d.pledger.underwriting }.sort_by(&:created_at).reverse

    respond_to do |format|
      format.html { render layout: 'generate' }
    end
  end

  # GET /donations/new
  # GET /donations/new.json
  def new
    @donation = Donation.new
    @donationID = 'new'
    @selectedSemester = Semester.current_semester
    begin
      @selectedSlot = Slot.on_now.id
    rescue
      @selectedSlot = 0
    end

    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render json: @donation }
    end
  end

  # GET /donations/1/edit
  def edit
    @donation = Donation.find(params[:id])
    @donationID = params[:id]
    @selectedSemester = @donation.slot.semester
    @selectedSlot = @donation.slot.id

    respond_to do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  # POST /donations
  # POST /donations.json
  def create
    pledgerID = params[:donation].delete(:pledger_id)
    @pledger = Pledger.find(pledgerID)
    @donation = @pledger.donations.create(params[:donation])

    @donation.phone_operator = current_user.username
    if @donation.payment_method == 'Credit Card'
      @donation.pledge_form_sent = true
      @donation.payment_received = true
      @donation.gpo_sent = true
      @donation.gpo_processed = false
    end

    respond_to do |format|
      if @donation.save
        format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
        format.json { render json: @donation, status: :created, location: @donation }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /donations/1
  # PUT /donations/1.json
  def update
    pledgerID = params[:donation].delete(:pledger_id)
    @pledger = Pledger.find(pledgerID)
    @donation = Donation.find(params[:id])
    if params[:donation][:payment_method] == 'Credit Card'
      params[:donation][:pledge_form_sent] = true
      params[:donation][:payment_received] = true
      params[:donation][:gpo_sent] = true
      params[:donation][:gpo_processed] = false
    end
    if (@donation.payment_method == 'Credit Card' && @donation.gpo_processed == false) && (params[:donation][:payment_method] != 'Credit Card')
      params[:donation][:pledge_form_sent] = false
      params[:donation][:payment_received] = false
      params[:donation][:gpo_sent] = false
    end
    respond_to do |format|
      if @donation.update_attributes(params[:donation])
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    @donation = Donation.find(params[:id])
    @pledger = @donation.pledger
    @donation.destroy

    respond_to do |format|
      format.js
    end
  end

  def forgive
    @semester = Semester.find(params[:semester])
    unpaid_donations = @semester.slots.reduce([]) { |dons, sem| dons + sem.donations }.select { |d| !d.payment_received }
    unpaid_donations.each do |don|
      ForgivenDonation.create do |fd|
        fd.amount = don.amount
        fd.gpo_processed = don.gpo_processed
        fd.gpo_sent = don.gpo_sent
        fd.payment_method = don.payment_method
        fd.payment_received = don.payment_received
        fd.pledge_form_sent = don.pledge_form_sent
        fd.slot_id = don.slot_id
        fd.phone_operator = don.phone_operator
        fd.pledger_id = don.pledger_id
      end
      don.destroy
    end
    respond_to do |format|
      format.html { redirect_to donations_path + "/#{@semester.name}" }
    end
  end

end
