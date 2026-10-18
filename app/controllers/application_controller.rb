class ApplicationController < ActionController::Base
  after_action :track_page_view

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def track_page_view
    AnalyticsTracker.enqueue(request, response)
  end
end
