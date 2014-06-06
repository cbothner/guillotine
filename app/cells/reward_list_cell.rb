class RewardListCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :current_user
  helper PledgersHelper, ApplicationHelper

  def show(params)
    @pledger = params[:pledger]

    rewards = @pledger.rewards.includes(:item)
    @activeRewards = rewards.select { |e| e.premia_sent == false }
    @archivedRewards = rewards - @activeRewards

    render
  end
end
