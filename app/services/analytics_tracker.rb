class AnalyticsTracker
  def self.enqueue(request, response)
    return unless trackable?(request, response)

    TrackPageViewJob.perform_later(
      path: request.path,
      ip: request.remote_ip,
      referrer: request.referer,
      user_agent: request.user_agent,
      country_code: country_code(request),
      post_slug: post_slug_for(request)
    )
  end

  def self.record_payload(payload)
    PageView.create!(
      post: Post.published.find_by(slug: payload["post_slug"]),
      path: payload.fetch("path"),
      ip_hash: anonymized_ip(payload.fetch("ip")),
      referrer_host: referrer_host(payload["referrer"]),
      user_agent: payload["user_agent"].to_s.first(500),
      country_code: payload["country_code"],
      viewed_at: Time.current
    )
  rescue StandardError => error
    Rails.logger.warn("Analytics tracking failed: #{error.class}: #{error.message}")
  end

  def self.trackable?(request, response)
    request.get? && request.format.html? && response.successful? && !request.path.start_with?("/admin")
  end

  def self.post_slug_for(request)
    return unless request.path.start_with?("/writings/")

    request.path.delete_prefix("/writings/")
  end

  def self.anonymized_ip(ip)
    daily_salt = Date.current.iso8601
    Digest::SHA256.hexdigest("#{Rails.application.secret_key_base}:#{daily_salt}:#{ip}")
  end

  def self.referrer_host(referrer)
    URI.parse(referrer).host if referrer.present?
  rescue URI::InvalidURIError
    nil
  end

  def self.country_code(request)
    return unless ENV["TRUST_GEO_HEADERS"] == "true"

    request.get_header("HTTP_CF_IPCOUNTRY").to_s.upcase.presence
  end
end
