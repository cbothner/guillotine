module Semesters
  class PledgesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_semester

    layout 'generate'

    def show
      set_donation_totals_by_pledger_id
      set_last_donation_time_by_pledger_id
      set_taxable_totals_by_pledger_id
      set_pledgers
    end

    def update
      update_scoped_donations pledge_form_sent: true
      update_scoped_rewards taxed: true

      redirect_to semester_pledges_path(@semester),
                  notice: 'Pledge forms marked sent; Rewards marked taxed'
    end

    private

    def set_semester
      @semester = Semester.find params[:semester_id]
    end

    def set_donation_totals_by_pledger_id
      @donation_totals_by_pledger_id =
        donation_scope.group(:pledger_id).sum(:amount)
    end

    def set_last_donation_time_by_pledger_id
      @last_donation_time_by_pledger_id =
        donation_scope.group(:pledger_id).maximum(:created_at)
    end

    def set_taxable_totals_by_pledger_id
      @taxable_totals_by_pledger_id =
        reward_scope.joins(:item).group(:pledger_id).sum('items.taxable_value')
      @taxable_totals_by_pledger_id.default = '0.0'
    end

    def set_pledgers
      @pledgers = Pledger.where(id: @donation_totals_by_pledger_id.keys)
                         .order(Arel.sql('lower(name) ASC'))
    end

    def update_scoped_donations(params)
      donation_scope.update_all params
    end

    def update_scoped_rewards(params)
      reward_scope.update_all params
    end

    def donation_scope
      @semester.donations.pledge_form_unsent.by_check
    end

    def reward_scope
      Reward.untaxed
    end
  end
end
