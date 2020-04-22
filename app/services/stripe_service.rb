class StripeService
  class << self
    # service to Subscribe a Trainer
    def create_customer(user, card_params)
      if !user.stripe_id.present?
        stripe = Stripe::Customer.create({
          email: user.email
        })
        user.stripe_id = stripe.id
        add_credit_card(user, card_params)
        set_primary_card(user, user.credit_cards.last)
        plan_id = card_params[:plan] == "yearly" ? 'plan_GNQpwYzH4ZIcth' : 'plan_GNQrJT9PN9GFLy'
        trial = card_params[:free_trial].present? ? (Time.now + 14.days).to_i : ''
        user.plan_id = plan_id
        user.update(stripe_id: stripe.id, plan_id: plan_id)
      end
      if card_params[:plan].present? 
        plan_id = card_params[:plan] == "yearly" ? 'plan_GNQpwYzH4ZIcth' : 'plan_GNQrJT9PN9GFLy'
        user.plan_id = plan_id
        user.update(plan_id: plan_id)
      end
      trial = card_params[:free_trial].present? ? 14 : 0
      update_trial_days(user, trial)
      recurring_payment = card_params[:recurring_payments]
      coupon = card_params[:trainer_coupon_code].present? ? card_params[:trainer_coupon_code] : ''
      charge_payment(user, recurring_payment, coupon, card_params[:device_token], card_params[:device_type])
      user.update(subscription: "active")
    end

    # service to charge Subscription of a trainer
    def charge_payment(user, recurring_payment, coupon, device_token, device_type)
      coupon_user = User.where(trainer_coupon_code: coupon).first
      charge_obj = recurring_payment == 'true' ? automatic_payments(user, coupon_user) : invoice_payments(user, coupon_user)
      charge = Stripe::Subscription.create(charge_obj)
      user.update(subscription_id: charge.id)
      if user.subscription_id.present? && user.clients.length == 0
        user.device_tokens.build(device_token: device_token,device_type: device_type).save if device_token.present? && user.device_tokens.where(device_token: device_token).count == 0
        notification = user.notifications.build(notification_type: 1, notification_text: 1, to_user_id: user.id)
        user.send_notifications(notification, notification_params = {}) if notification.save
      else
        user.device_tokens.destroy_all if user && user.device_tokens.length > 0
      end
      user.payment_histories.create!({ amount: (charge.plan.amount.to_i)/100, credit_card_id: user.credit_cards.try(:last).try(:id), cc_number: cc_number(user.credit_cards.try(:last).try(:cc_number)) })
      AwsSesMailer.welcome_email(user, options = { subject: 'BodyFrame Subscription Renewed'}).deliver_now
      # AwsSesMailer.welcome_email(user, options = { subject: 'Your Payment Was Declined'}).deliver_now
      if coupon_user.present? && coupon_user != user && coupon_user.status?
        coupon_notification = user.notifications.build(notification_type: 12, notification_text: 12, to_user_id: coupon_user.id)
        user.send_notifications(coupon_notification, notification_params = { trainer_name: user.full_name }) if coupon_notification.save
        user.update(coupon_used: true)

        total_amount = ('%.2f' % (coupon_user.wallet_amount.to_i + ((charge.plan.amount.to_i) * 20)/10000))
        coupon_user.wallet_amount == "0" ? coupon_user.admin_payouts.create(amount_requested: total_amount) : ( coupon_user.admin_payouts.count > 0 ? coupon_user.admin_payouts.last.update(amount_requested: total_amount) : '')
        AwsSesMailer.welcome_email(coupon_user, options = { subject: 'Referral acceptance'}).deliver_now
        user.payment_histories.last.update(reward_total: total_amount, reward_to_trainer: total_amount) if user.coupon_used?
        coupon_user.update(wallet_amount: total_amount)
      end
    end
    
    # service to create a client subscription
    def client_subscription(user, card_params)
      add_credit_card(user, card_params)
      set_primary_card(user, user.credit_cards.last)
      client_charge(user, card_params)
    end

    # service to charge client Payments
    def client_charge(user, card_params)
      amount = (card_params[:amount].to_d * 4.95)/100
      total_amount =  (user.try(:trainer).try(:wallet_amount).present? ? user.trainer.wallet_amount : "0").to_d + ( card_params[:amount].to_d - amount.to_d)
      card_amount = card_params[:amount].to_i * 100

      charge = Stripe::Charge.create({
        amount: card_amount - amount.to_i,
        currency: 'usd',
        customer: user.stripe_id,
        source: user.credit_cards.try(:last).try(:card_id),
        description: 'Charge for #{user.email}',
      })

      if user.subscription == "pending"
        notification1 = user.notifications.build(notification_type: 2, notification_text: 2, to_user_id: user.trainer.id)
        user.send_notifications(notification1, notification_params = {}) if notification1.save
      end

      if charge.id.present?
        AwsSesMailer.welcome_email(user, options = { subject: 'BodyFrame Subscription Renewed'}).deliver_now
        user.update(charge_id: charge.id, subscription: "active")
        notification = user.notifications.build(notification_type: 3, notification_text: 3, to_user_id: user.trainer.id)
        user.send_notifications(notification, notification_params = {}) if notification.save
      end
      request = UpgradeRequest.where(client_id: user.id, status: "requested").last
      request.accepted! if request.present?
      if card_params[:upgrade_request_id].present?
        upgrade_request = UpgradeRequest.find(card_params[:upgrade_request_id].to_i)
        upgrade_request.accepted!
        user.trainer_invites.create(full_name: upgrade_request.client.full_name, phone: upgrade_request.client.phone, user_type: "client", email: upgrade_request.client.email, monthly_amount: upgrade_request.monthly_amount, session_count: upgrade_request.session_count, session_amount: upgrade_request.session_amount, per_session_amount: upgrade_request.per_session_amount) if upgrade_request.client.present?
        notification = user.notifications.build(notification_type: 18, notification_text: 18, to_user_id: user.trainer_id)
        notification_params = { client_name: user.full_name }
        user.send_notifications(notification, notification_params) if notification.save
      end
      user.trainer.update(wallet_amount: ('%.2f' % total_amount.to_f)) if user.trainer.status?
      user.trainer.wallet_amount == "0" && user.trainer.status? ? user.trainer.admin_payouts.create(amount_requested: total_amount) : (user.trainer.present? && user.trainer.status? && user.trainer.admin_payouts.present? ? user.trainer.admin_payouts.last.update(amount_requested: total_amount) : user.trainer.admin_payouts.create(amount_requested: total_amount))

      plan = user.charge_id.present? ? card_params[:plan] : 'declined'
      session_count = user.charge_id.present? && user.trainer.trainer_invites.where(email: user.email).try(:last).try(:session_count) != 0 ? user.trainer.trainer_invites.where(email: user.email).try(:last).try(:session_count) : 0
      per_session_amount = user.charge_id.present? && user.trainer.trainer_invites.where(email: user.email).try(:last).try(:per_session_amount)

      PaymentHistory.create({ user_id: user.try(:trainer_id), client_id: user.try(:id), amount: (card_params[:amount].to_d), credit_card_id: user.credit_cards.try(:last).try(:id), plan: plan, cc_number: cc_number(user.credit_cards.try(:last).try(:cc_number)), reward_total: amount, session_count: session_count, per_session_amount: per_session_amount, admin_payout_id: user.try(:trainer).try(:admin_payouts).try(:last).try(:id)})
      # - (card_params[:amount].to_d * 4.95)/100.to_d
    end

    def update_trial_days(user, trial)
      Stripe::Plan.update(
        user.plan_id,
        { 
          trial_period_days: trial
        }
      )
    end

    def automatic_payments(user, coupon_user)
      {
        customer: user.stripe_id,
        coupon: coupon_user.present? && !user ? coupon_user.id : '',
        collection_method: 'charge_automatically',
        items: [{
          plan: user.plan_id
        }]
      }
    end

    def invoice_payments(user, coupon_user)
      {
        customer: user.stripe_id,
        coupon: coupon_user.present? && !user ? coupon_user.id : '',
        collection_method: 'send_invoice',
        days_until_due: 30,
        items: [{
          plan: user.plan_id
        }]
      }
    end

    def generate_card_token(card_params)
      Stripe::Token.create({
        card: {
          number: card_params[:cc_number],
          exp_month: card_params[:expiry][0..1].to_i,
          exp_year: card_params[:expiry][-4..-1].to_i,
          cvc: card_params[:cvv]
        }
      })
    end
    
    def add_credit_card(user, card_params)
      if !user.stripe_id.present?
        stripe = Stripe::Customer.create({
          email: user.email
        })
        user.update(stripe_id: stripe.id)
      end
      cc_token = generate_card_token(card_params)
      card = Stripe::Customer.create_source(
        user.stripe_id,
        { source: cc_token }
      )
      credit_card = user.credit_cards.create(customer_name: card_params[:customer_name], cc_number: cc_number(card_params[:cc_number]), expiry: card_params[:expiry], cc_token: cc_token.id, country: card_params[:country], zipcode: card_params[:zipcode], card_id: card.id, card_type: card.brand)
      AwsSesMailer.welcome_email(user, options = { subject: 'New Payment Method Added'}).deliver_now
    end

    def remove_credit_card(user, card)
      stripe = Stripe::Customer.delete_source(
       user.stripe_id,
       card.card_id
      )
    end

    def set_primary_card(user, card)
      Stripe::Customer.update(
        user.stripe_id,
        { default_source: card.card_id }
      )
      card.update(status: "primary")
      user.credit_cards.where.not(id: card.id).update_all(status: "secondary")
    end

    def cancel_subscription(user)
      Stripe::Subscription.delete(user.subscription_id)
    end

    def cc_number(card)
      'XXXXXXXXXXXX' + card[-4..-1]
    end
  end
end
