class DonationListCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :current_user
  helper PledgersHelper, ApplicationHelper

  def show(params)
    @pledger = params[:pledger]
    donations = @pledger.donations.includes(slot: [:show, :semester])
    @activeDonations = donations.select { |d| d.active?(current_user == User.where(username: 'dd')[0]) }
    @archivedDonations = donations - @activeDonations
    forgivenDonations = @pledger.forgiven_donations.includes(slot: [:semester])
    @forgivenTotal = forgivenDonations.reduce(0) { |sum, don| sum + don.amount }
    @forgivenSemesters = forgivenDonations.group_by { |d| d.slot.semester }.count

    render
  end

end
