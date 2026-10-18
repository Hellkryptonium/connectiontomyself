require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "privacy page is publicly available" do
    get privacy_url

    assert_response :success
    assert_includes response.body, "Privacy"
  end

  test "public page views are recorded" do
    payload = {
      "path" => "/privacy",
      "ip" => "127.0.0.1",
      "referrer" => nil,
      "user_agent" => "test browser",
      "country_code" => nil,
      "post_slug" => nil
    }

    assert_difference("PageView.count", 1) do
      AnalyticsTracker.record_payload(payload)
    end
  end
end
