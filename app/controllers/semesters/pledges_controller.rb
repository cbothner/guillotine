module Semesters
  class PledgesController < ApplicationController
    before_action :authenticate_user!

    layout 'generate'

    def index
      set_semester
      set_donation_totals_by_pledger_id
      set_last_donation_time_by_pledger_id
      set_taxable_totals_by_pledger_id
      set_pledgers
    end

    private

    def set_semester
      @semester = Semester.find params[:semester_id]
    end

    def set_donation_totals_by_pledger_id
      @donation_totals_by_pledger_id =
        @semester.donations.merge(donation_scope)
                 .group(:pledger_id).sum(:amount)
    end

    def set_last_donation_time_by_pledger_id
      @last_donation_time_by_pledger_id =
        @semester.donations.merge(donation_scope)
                 .group(:pledger_id).maximum(:created_at)
    end

    def set_taxable_totals_by_pledger_id
      @taxable_totals_by_pledger_id =
        Reward.untaxed.joins(:item)
              .group(:pledger_id).sum('items.taxable_value')
      @taxable_totals_by_pledger_id.default = '0.0'
    end

    def set_pledgers
      @pledgers = Pledger.where(id: @donation_totals_by_pledger_id.keys)
                         .order(Arel.sql('lower(name) ASC'))
    end

    def donation_scope
      Donation.pledge_form_unsent.by_check
    end
  end
end
