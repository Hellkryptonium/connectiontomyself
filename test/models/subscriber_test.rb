require "test_helper"

class SubscriberTest < ActiveSupport::TestCase
  test "normalizes email and confirms subscription" do
    subscriber = Subscriber.create!(email: " Person@Example.COM ")

    assert_equal "person@example.com", subscriber.email
    assert_equal "pending", subscriber.status
    assert subscriber.confirmation_token.present?

    subscriber.confirm!
    assert_equal "active", subscriber.status
    assert subscriber.confirmed_at.present?
  end
end
