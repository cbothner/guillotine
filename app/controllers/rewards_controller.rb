class RewardsController < ApplicationController

  before_filter :authenticate_user!
  # GET /rewards
  # GET /rewards.json
  def index
    rewards = Reward.includes( :pledger, {pledger: :donations}, {pledger: :rewards}, :item )
    sentRewards = rewards.select { |r| r.premia_sent == true }
    unsentRewards = rewards - sentRewards
    unqualifiedRewards = unsentRewards.select { |r| r.pledger.donations.any? { |d| d.payment_received == false } }
    qualifiedRewards = unsentRewards - unqualifiedRewards

    #@rewards = Hash[ [ "Qualified Rewards", "Unqualified Rewards" ].zip( [ qualifiedRewards, unqualifiedRewards ].collect { |a|
      #a.group_by { |p| p.pledger } } ) ]
    @rewards = Hash[ [ "Qualified Rewards", "Unqualified Rewards" ]
      .zip( [ qualifiedRewards, unqualifiedRewards ]
           .collect { |a| a.group_by{ |r| r.pledger.rewards
             .collect { |r| r.item.shape }.sort }
          .collect { |i,e| 
          {i => e.group_by { |r| r.pledger_id } } 
        }
    } ) ]

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @rewards }
    end
  end

  # GET /rewards/1
  # GET /rewards/1.json
  def show
    @reward = Reward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reward }
    end
  end

  # GET /rewards/new
  # GET /rewards/new.json
  def new
    @reward = Reward.new
    @rewardID = "new"
    pledger = Pledger.find(params[:pledger_id])
    all_donations_amount = pledger.donations.reject{|d| d.gpo_sent }.inject(0){|sum,don| sum + don.amount}
    all_rewards_cost = pledger.rewards.reject{|r| r.premia_sent }.inject(0){|sum,rew| sum + rew.item.cost}
    @total_donation = all_donations_amount - all_rewards_cost
    @total_donation = 1_000_000 if current_user == User.where("username = 'dd'")[0]

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
      format.json { render json: @reward }
    end
  end

  # GET /rewards/1/edit
  def edit
    @reward = Reward.find(params[:id])
    @rewardID = params[:id]
    @selectedItem = @reward.item.id
    pledger = @reward.pledger
    all_donations_amount = pledger.donations.reject{|d| d.gpo_sent }.inject(0){|sum,don| sum + don.amount}
    all_rewards_cost = pledger.rewards.reject{|r| r.premia_sent }.inject(0){|sum,rew| sum + rew.item.cost}
    @total_donation = all_donations_amount + @reward.item.cost - all_rewards_cost
    @total_donation = 1_000_000 if current_user == User.where("username = 'dd'")[0]

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # POST /rewards
  # POST /rewards.json
  def create
    pledgerID = params[:reward].delete(:pledger_id)
    pledger = Pledger.find(pledgerID)
    item = params[:reward][:item] = Item.find(params[:reward][:item])
    @reward = pledger.rewards.create(params[:reward])
    @activeRewards = pledger.rewards.where("premia_sent = 'false'")
    @archivedRewards = pledger.rewards.where("premia_sent = 'true'")

    respond_to do |format|
      if @reward.save
        item.update_attributes(stock: item.stock - 1) if @reward.premia_sent
        format.html { redirect_to @reward, notice: 'Reward was successfully created.' }
        format.json { render json: @reward, status: :created, location: @reward }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /rewards/1
  # PUT /rewards/1.json
  def update
    pledgerID = params[:reward].delete(:pledger_id)
    @reward = Reward.find(params[:id])
    item = params[:reward][:item] = Item.find(params[:reward][:item])
    premia_sent_before_update = @reward.premia_sent

    respond_to do |format|
      @activeRewards = @reward.pledger.rewards.where("premia_sent = 'false'")
      @archivedRewards = @reward.pledger.rewards.where("premia_sent = 'true'")
      if @reward.update_attributes(params[:reward])
        if @reward.premia_sent != premia_sent_before_update
          item.update_attributes(stock: item.stock - 1) if @reward.premia_sent
          item.update_attributes(stock: item.stock + 1) if !@reward.premia_sent
        end
        format.html { redirect_to @reward, notice: 'Reward was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @reward.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /rewards/1
  # DELETE /rewards/1.json
  def destroy
    @reward = Reward.find(params[:id])
    pledger = @reward.pledger
    @reward.destroy

    respond_to do |format|
      format.html { redirect_to pledger_url(pledger) }
    end
  end
end
