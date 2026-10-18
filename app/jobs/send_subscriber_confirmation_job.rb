class SendSubscriberConfirmationJob < ApplicationJob
  queue_as :default

  discard_on ActiveRecord::RecordNotFound

  def perform(subscriber_id)
    ResendDelivery.send_confirmation(Subscriber.find(subscriber_id))
  end
end
