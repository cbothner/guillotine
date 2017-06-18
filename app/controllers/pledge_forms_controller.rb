class PledgeFormsController < ApplicationController
  before_action :set_pledgers
  before_action :set_donations
  before_action :set_rewards

  def index
    render layout: "generate"
  end

  def all
    render layout: "printout"
  end

  def mark_all_sent
    @donations.each do |d|
      d.update pledge_form_sent: 'true'
    end
    redirect_to action: 'index'
  end


  private
  def set_pledgers
    @pledgers = Pledger
      .joins(:donations)
      .where(donations: {pledge_form_sent: false}).uniq
  end
  def set_donations
    @donations = Donation
      .where(pledger_id: @pledgers.select('pledgers.id'))
      .order(amount: :desc)
  end
  def set_rewards
    @rewards = Reward.where(premia_sent: false)
  end
end
