class GpoController < ApplicationController
  def single
    @pledger = Pledger.find(params[:id])

    # Sum value of unprocessed cheque
    checksForDeposit = @pledger.donations.where("payment_received = 'true' and gpo_sent = 'false'")
    @depositTotal = checksForDeposit.inject(0){ |sum,e| sum += e.amount }

    # Sum value of unsent premia
    unsentPremia = @pledger.rewards.where("premia_sent = 'false' and taxed = 'false'")
    @premiaTotal = unsentPremia.inject(0){ |sum,e| sum += e.item.taxable_value }

    #TODO Set taxed = true after PDFs are generated
    
    @giftTotal = @depositTotal - @premiaTotal

    @pledger.perm_phone = @pledger.perm_phone == '(000) 000-0000' ? "No Phone" : @pledger.perm_phone
    @pledger.email = @pledger.email.blank? ? "No Email" : @pledger.email

    respond_to do |format|
      format.pdf { render :layout => true, formats: [:pdf]
        # Mark GPOs sent
        checksForDeposit.each do |donation|
          donation.update_attributes({:gpo_sent => "true"})
        end
      }
    end
    
  end

  def all
    checksForDeposit = Donation.where("payment_received = 'true' and gpo_sent = 'false'")

    # Unique list of pledgers in checksForDeposit
    pledgersForGPO = checksForDeposit.map{ |don| don.pledger_id }.uniq
    @argsForGPO = pledgersForGPO.map{ |id|
      pledger = Pledger.find(id)
      pledger.perm_phone ||= "No Phone"
      pledger.email ||= "No Email" 
      { :pledger => pledger, 
        :depositTotal => checksForDeposit
          .select{ |don| don.pledger_id == id }
          .inject(0){ |sum,e| sum += e.amount },
        :premiaTotal => pledger.rewards.where("premia_sent = 'false' and taxed = 'false'")
          .inject(0){ |sum,e| sum+= e.item.taxable_value }
      }
    }

    respond_to do |format|
      format.html { render :layout => "generate" }
      format.pdf { render :layout => true, format: [:pdf]
        # Mark GPOs sent
        checksForDeposit.each do |donation|
          donation.update_attributes({:gpo_sent => "true"})
        end
      }
    end
  end
end
