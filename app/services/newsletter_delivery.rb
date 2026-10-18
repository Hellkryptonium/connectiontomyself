class NewsletterDelivery
  def self.configured?
    ResendDelivery.configured?
  end

  def self.send_newsletter(newsletter)
    raise "Resend is not configured" unless configured?
    raise "Newsletter is not a draft" unless newsletter.status == "draft"

    Subscriber.where(status: "active").find_each do |subscriber|
      Resend::Emails.send(
        {
          from: ENV.fetch("NEWSLETTER_FROM"),
          to: subscriber.email,
          subject: newsletter.subject,
          html: render_html(newsletter, subscriber)
        }
      )
    end

    newsletter.update!(status: "sent", sent_at: Time.current)
  end

  def self.render_html(newsletter, subscriber)
    unsubscribe_url = Rails.application.routes.url_helpers.unsubscribe_subscription_url(
      subscriber.confirmation_token,
      host: ENV.fetch("APP_HOST"),
      port: ENV["APP_PORT"],
      protocol: ENV.fetch("APP_PROTOCOL", "https")
    )

    <<~HTML
      <h1>#{ERB::Util.html_escape(newsletter.subject)}</h1>
      #{MarkdownRenderer.call(newsletter.body_markdown)}
      <p><small><a href="#{ERB::Util.html_escape(unsubscribe_url)}">Unsubscribe</a></small></p>
    HTML
  end

  private_class_method :render_html
end
