class Admin::SubscribersController < Admin::BaseController
  before_action :set_subscriber, only: :resend_confirmation

  def index
    @subscribers = Subscriber.order(created_at: :desc)
  end

  def resend_confirmation
    if @subscriber.active?
      redirect_to admin_subscribers_path, alert: "This subscriber is already active."
    elsif !ResendDelivery.configured?
      redirect_to admin_subscribers_path, alert: "Configure Resend before sending confirmation emails."
    else
      SendSubscriberConfirmationJob.perform_later(@subscriber.id)
      redirect_to admin_subscribers_path, notice: "Confirmation email queued."
    end
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find(params[:id])
  end
end
