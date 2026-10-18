class ApplicationMailer < ActionMailer::Base
  default from: -> { ENV.fetch("NEWSLETTER_FROM", "no-reply@example.com") }
  layout "mailer"
end
