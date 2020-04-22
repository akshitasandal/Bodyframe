class Web::AdminPayoutsController < ApplicationController

    def approve
        admin_payout = AdminPayout.find(params[:id])
        admin_payout.update(payment: 2)
        redirect_to "/admin/admin_payouts"
    end

    def decline
        admin_payout = AdminPayout.find(params[:id])
        admin_payout.update(payment: 2)
        redirect_to "/admin/admin_payouts"
    end
end
