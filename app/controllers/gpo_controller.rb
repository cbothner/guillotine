class GpoController < ApplicationController
  def single
    @pledger = Pledger.find(params[:id])

    # Sum value of unprocessed cheque
    checksForDeposit = @pledger.donations.where("payment_received = 'true' and gpo_sent = 'false'")
    @depositTotal = checksForDeposit.reduce(0) { |sum, e| sum += e.amount }

    # Sum value of unsent premia
    unsentPremia = @pledger.rewards.where("premia_sent = 'false' and taxed = 'false'")
    @premiaTotal = unsentPremia.reduce(0) { |sum, e| sum += e.item.taxable_value }

    @giftTotal = @depositTotal - @premiaTotal

    @pledger.perm_phone = @pledger.perm_phone == '(000) 000-0000' ? 'No Phone' : @pledger.perm_phone
    @pledger.email = @pledger.email.blank? ? 'No Email' : @pledger.email

    respond_to do |format|
      format.pdf { render layout: true, formats: [:pdf]
                   # Mark GPOs sent
                   checksForDeposit.each do |donation|
                     donation.update_attributes(gpo_sent: true)
                   end
                   # Mark premia taxed
                   unsentPremia.each do |reward|
                     reward.update_attributes(taxed: true)
                   end
      }
    end
  end

  def all
    checksForDeposit = Donation.where("payment_received = 'true' and gpo_sent = 'false'")

    # Unique list of pledgers in checksForDeposit
    pledgersForGPO = checksForDeposit.map { |don| Pledger.find(don.pledger_id) }.uniq
    unsentPremia = pledgersForGPO.reduce([]) { |sum, p| sum + p.rewards.reject(&:taxed) }

    @argsForGPO = pledgersForGPO.map{ |pledger|
      pledger.perm_phone ||= 'No Phone'
      pledger.email ||= 'No Email'
      { pledger: pledger,
        depositTotal: checksForDeposit.select { |don| don.pledger_id == pledger.id }.reduce(0) { |sum, e| sum += e.amount },
        premiaTotal: pledger.rewards.reject(&:taxed).reduce(0) { |sum, e| sum += e.item.taxable_value }
      }
    }

    respond_to do |format|
      format.html { render layout: 'generate' }
      format.pdf { render layout: true, format: [:pdf]
                   # Mark GPOs sent
                   checksForDeposit.each do |donation|
                     donation.update_attributes(gpo_sent: 'true')
                   end
                   # Mark premia taxed
                   unsentPremia.each do |reward|
                     reward.update_attributes(taxed: true)
                   end
      }
    end
  end

  def creditcards
    unprocessed_cc_donations_by_pledger = Donation.where(payment_method: 'Credit Card', gpo_processed: 'false').includes(pledger: [:rewards]).group_by { |d| d.pledger }.to_a

    @arguments = unprocessed_cc_donations_by_pledger.map do |x|
      { pledger: x[0],
        donation_total: x[1].reduce(0) { |s, d| s + d.amount },
        tax_liability: x[0].rewards.select { |r| !r.taxed }.reduce(0) { |s, r| s + r.item.taxable_value }
      }
    end
    @arguments.each do |a|
      a[:tax_exempt_donation] = a[:donation_total] - a[:tax_liability]
    end
    @arguments = @arguments.sort_by { |a| a[:pledger].name.upcase }

    respond_to do |format|
      format.html { render layout: 'generate' }
    end
  end

  def process_creditcards
    unprocessed_cc_donations_by_pledger = Donation.where(payment_method: 'Credit Card', gpo_processed: 'false').includes(pledger: [:rewards]).group_by { |d| d.pledger }.to_a
    unprocessed_donations = unprocessed_cc_donations_by_pledger.map { |x| x[1] }.flatten
    untaxed_rewards = unprocessed_cc_donations_by_pledger.map{ |x| x[0].rewards.select { |r| !r.taxed } }.flatten

    unprocessed_donations.each { |x| x.update_attributes(gpo_processed: true) }
    untaxed_rewards.each { |x| x.update_attributes(taxed: true) }

    respond_to do |format|
      format.html { redirect_to controller: 'gpo', action: 'creditcards', notice: 'Successfully processed Credit Card GPOs.' }
    end
  end
end
