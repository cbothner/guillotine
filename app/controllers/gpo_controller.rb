class GpoController < ApplicationController
  def single
    @pledger = Pledger.find(params[:id])

    # Sum value of unprocessed cheques
    checksForDeposit = @pledger.donations.where("payment_received = 'true' and gpo_sent = 'false'")
    @depositTotal = checksForDeposit.inject(0){ |sum,e| sum += e.amount }

    # Sum value of unsent premia
    unsentPremia = @pledger.rewards.where("premia_sent = 'false'")
    @premiaTotal = unsentPremia.inject(0){ |sum,e| sum += e.item.taxable_value }

    @giftTotal = @depositTotal - @premiaTotal

    respond_to do |format|
      format.pdf { render :layout => true, formats: [:pdf]}
    end
    
    # Mark GPOs sent
    checksForDeposit.each do |donation|
      donation.update_attributes({:gpo_sent => "true"})
    end
  end

  def all
  end
end
