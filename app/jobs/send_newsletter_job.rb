class SendNewsletterJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(newsletter_id)
    NewsletterDelivery.send_newsletter(Newsletter.find(newsletter_id))
  end
end
