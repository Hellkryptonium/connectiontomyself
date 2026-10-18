class TrackPageViewJob < ApplicationJob
  queue_as :default

  def perform(payload)
    AnalyticsTracker.record_payload(payload)
  end
end
