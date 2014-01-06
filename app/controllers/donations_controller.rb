class DonationsController < ApplicationController
  layout "slots"

  before_filter :authenticate_user!
  # GET /donations
  # GET /donations.json
  def index
    @semester = Semester.where(month: params[:month], year: params[:year])[0]
    @semester ||= Semester.current_semester

    donations = @semester.slots.inject([]){|dons, sem| dons+sem.donations}
    @total_progress = donations.inject(0){|sum,don| sum+don.amount}
    @total_percent = 100 * (@total_progress / @semester.goal)

    unpaid_donations = donations.select{ |d| d.payment_received == false}
    @unpaid_progress = unpaid_donations.inject(0){|sum,don| sum+don.amount}
    @unpaid_pledgers = unpaid_donations.map{|d| d.pledger}
                                       .uniq
                                       .map do |pled|
                                         pledger_total = pled.donations.select{|d| d.payment_received == false and d.slot.semester == @semester}.inject(0) do |sum,don|
                                           sum + don.amount
                                         end
                                         {pledger: pled, amount: pledger_total}
                                       end
    @unpaid_pledgers = @unpaid_pledgers.sort_by{|x| x[:amount]}.reverse

    paid_donations = donations.select{ |d| d.payment_received == true}
    @paid_progress = paid_donations.inject(0){|sum,don| sum+don.amount}
    @paid_pledgers = paid_donations.map{|d| d.pledger}
                                       .uniq
                                       .map do |pled|
                                         pledger_total = pled.donations.select{|d| d.payment_received == true and d.slot.semester == @semester}.inject(0) do |sum,don|
                                           sum + don.amount
                                         end
                                         {pledger: pled, amount: pledger_total}
                                       end
    @paid_pledgers = @paid_pledgers.sort_by{|x| x[:amount]}.reverse
    begin
      @paid_percent = 100 * (@paid_progress / @total_progress)
    rescue # If it's division by zero, which will be the initial state every semester.
      @paid_percent = 0
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @donations }
    end
  end

   #GET /donations/1.pdf
  def show
    @donation = Donation.find(params[:id])
    @pledger = @donation.pledger

    respond_to do |format|
      format.pdf { render :layout => "application", formats: [:pdf] }
    end
  end

  # GET /donations/new
  # GET /donations/new.json
  def new
    @donation = Donation.new
    @donationID = "new"
    @selectedSemester = Semester.current_semester
    @selectedShow = Slot.on_now

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.json { render json: @donation }
      format.pdf { render :layout => "application", formats: [:pdf] }
    end
  end

  # GET /donations/1/edit
  def edit
    @donation = Donation.find(params[:id])
    @donationID = params[:id]
    @selectedSemester = @donation.slot.semester
    @selectedSlot = @donation.slot.id

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # POST /donations
  # POST /donations.json
  def create
    pledgerID = params[:donation].delete(:pledger_id)
    @pledger = Pledger.find(pledgerID)
    @donation = @pledger.donations.create(params[:donation])
    @activeDonations = @pledger.donations.where("payment_received = 'false'")
    @archivedDonations = @pledger.donations.where("payment_received = 'true'")

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
    pledgerID = params[:donation].delete(:pledger_id)
    @pledger = Pledger.find(pledgerID)
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

  def pledge_forms
    @donations = Donation.where(pledge_form_sent: false)
    @rewards = Reward.where(premia_sent: false)
    @pledgers = @donations.map{ |d| d.pledger }.uniq

    respond_to do |format|
      format.html{ render :layout => 'generate' }
      format.pdf do
        render :layout => 'application', formats: [:pdf]
        @donations.each do |d|
          d.pledge_form_sent = true
          d.save
        end
      end
    end
  end
end
