class Admin::BaseController < ApplicationController
  SESSION_LIFETIME = 12.hours

  before_action :require_admin

  helper_method :current_admin

  private

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:admin_user_id])
  end

  def require_admin
    authenticated_at = session[:admin_authenticated_at].presence && Time.at(session[:admin_authenticated_at].to_i)
    if current_admin && authenticated_at && authenticated_at > SESSION_LIFETIME.ago
      return
    end

    reset_session
    redirect_to admin_login_path, alert: "Please sign in to continue."
  end
end
