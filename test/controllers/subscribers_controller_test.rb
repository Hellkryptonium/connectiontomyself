require "test_helper"

class SubscribersControllerTest < ActionDispatch::IntegrationTest
  test "rejects a duplicate pending subscription" do
    email = "reader-#{SecureRandom.hex(4)}@example.com"
    Subscriber.create!(email: email)

    post subscribe_url, params: { email: email }

    assert_redirected_to subscribe_url
    follow_redirect!
    assert_includes response.body, "already awaiting confirmation"
  end
end
