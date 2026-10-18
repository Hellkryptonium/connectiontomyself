class SubscribersController < ApplicationController
  def create
    email = params[:email].to_s.strip.downcase
    subscriber = Subscriber.find_by(email: email)
    if subscriber&.active?
      redirect_to subscribe_path, alert: "That email is already subscribed."
      return
    elsif subscriber&.pending?
      redirect_to subscribe_path, alert: "That email is already awaiting confirmation."
      return
    end

    subscriber ||= Subscriber.new(email: email)
    should_send_confirmation = subscriber.new_record? || subscriber.status == "unsubscribed"
    if subscriber.status == "unsubscribed"
      subscriber.confirmation_token = SecureRandom.urlsafe_base64(32)
      subscriber.confirmed_at = nil
      subscriber.unsubscribed_at = nil
    end
    subscriber.status = "pending" if should_send_confirmation

    if subscriber.save
      SendSubscriberConfirmationJob.perform_later(subscriber.id) if should_send_confirmation && ResendDelivery.configured?
      redirect_to subscribe_path, notice: confirmation_message
    else
      redirect_to subscribe_path, alert: subscriber.errors.full_messages.to_sentence
    end
  end

  def confirm
    subscriber = Subscriber.find_by!(confirmation_token: params[:token])
    subscriber.confirm!
    redirect_to subscribe_path, notice: "Your subscription is confirmed."
  end

  def unsubscribe
    subscriber = Subscriber.find_by!(confirmation_token: params[:token])
    subscriber.unsubscribe!
    redirect_to subscribe_path, notice: "You have been unsubscribed."
  end

  private

  def confirmation_message
    if ResendDelivery.configured?
      "Check your email to confirm your subscription."
    else
      "Your request was saved, but email delivery is not configured yet."
    end
  end
end
