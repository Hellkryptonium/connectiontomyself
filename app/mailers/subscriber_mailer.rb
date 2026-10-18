class SubscriberMailer < ApplicationMailer
  def self.configured?
    ResendDelivery.configured?
  end

  def confirmation(subscriber)
    @subscriber = subscriber
    @confirmation_url = confirm_subscription_url(subscriber.confirmation_token)
    mail(to: subscriber.email, from: ENV.fetch("NEWSLETTER_FROM"), subject: "Confirm your connectiontomyself subscription")
  end
end
