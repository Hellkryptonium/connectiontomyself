class Subscriber < ApplicationRecord
  STATUSES = %w[pending active unsubscribed].freeze

  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: STATUSES }

  before_validation :generate_confirmation_token, on: :create

  STATUSES.each do |subscriber_status|
    define_method("#{subscriber_status}?") { status == subscriber_status }
  end

  def confirm!
    update!(status: "active", confirmed_at: Time.current, unsubscribed_at: nil)
  end

  def unsubscribe!
    update!(status: "unsubscribed", unsubscribed_at: Time.current)
  end

  private

  def generate_confirmation_token
    self.confirmation_token ||= SecureRandom.urlsafe_base64(32)
  end
end
