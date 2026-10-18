class ResendDelivery
  def self.configured?
    ENV["RESEND_API_KEY"].present? && ENV["NEWSLETTER_FROM"].present? && ENV["APP_HOST"].present?
  end

  def self.send_confirmation(subscriber)
    raise "Resend is not configured" unless configured?

    message = SubscriberMailer.confirmation(subscriber)
    Resend::Emails.send(
      {
        from: ENV.fetch("NEWSLETTER_FROM"),
        to: subscriber.email,
        subject: message.subject,
        html: message.body.decoded
      }
    )
  end
end
