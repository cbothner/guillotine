class RewardsController < ApplicationController
  # GET /rewards
  # GET /rewards.json
  def index
    @rewards = Reward.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rewards }
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

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # POST /rewards
  # POST /rewards.json
  def create
    pledgerID = params[:reward].delete(:pledger_id)
    pledger = Pledger.find(pledgerID)
    params[:reward][:item] = Item.find(params[:reward][:item])
    @reward = pledger.rewards.create(params[:reward])
    @activeRewards = pledger.rewards.where("premia_sent = 'false'")
    @archivedRewards = pledger.rewards.where("premia_sent = 'true'")

    respond_to do |format|
      if @reward.save
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

    respond_to do |format|
      @activeRewards = @reward.pledger.rewards.where("premia_sent = 'false'")
      @archivedRewards = @reward.pledger.rewards.where("premia_sent = 'true'")
      if @reward.update_attributes(params[:reward])
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
