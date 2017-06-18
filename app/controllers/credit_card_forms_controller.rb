class CreditCardFormsController < ApplicationController
  layout 'printout'

  before_action :authenticate_user!

  # GET /donations/:donation_id/credit_card_form
  def show
    @donation = Donation.includes(:pledger).find(params[:donation_id])
  end

  # GET /credit_card_forms/new
  def new
  end

end
