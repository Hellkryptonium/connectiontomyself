require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "admin dashboard requires authentication" do
    get admin_root_url

    assert_redirected_to admin_login_url
  end

  test "expired admin sessions are rejected" do
    admin = AdminUser.create!(email: "admin-#{SecureRandom.hex(4)}@example.com", password: "a-secure-password")
    post admin_login_url, params: { email: admin.email, password: "a-secure-password" }

    travel 13.hours do
      get admin_root_url
    end

    assert_redirected_to admin_login_url
  end
end
