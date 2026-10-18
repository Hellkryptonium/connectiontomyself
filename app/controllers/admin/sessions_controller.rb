class Admin::SessionsController < ApplicationController
  before_action :redirect_authenticated_admin, except: :destroy
  rate_limit to: 10, within: 3.minutes, by: -> { request.remote_ip }, with: -> { redirect_to admin_login_path, alert: "Too many sign-in attempts. Try again later." }

  def new
  end

  def create
    admin = AdminUser.find_by(email: params[:email].to_s.downcase.strip)

    if admin&.authenticate(params[:password])
      reset_session
      session[:admin_user_id] = admin.id
      session[:admin_authenticated_at] = Time.current.to_i
      redirect_to admin_root_path
    else
      flash.now[:alert] = "Email or password was not recognized."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def redirect_authenticated_admin
    redirect_to admin_root_path if session[:admin_user_id]
  end
end
