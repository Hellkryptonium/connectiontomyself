# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

{
  "home" => [ "Hello, internet.", "Welcome to my little corner of the web." ],
  "about" => [ "About", "A little about the person behind this site" ],
  "now" => [ "Now", "What is happening here lately" ],
  "colophon" => [ "Colophon", "About this website" ],
  "uses" => [ "Uses", "Tools and setup" ],
  "privacy" => [ "Privacy", "How this site handles information" ]
}.each do |slug, (title, subtitle)|
  SitePage.find_or_create_by!(slug: slug) do |page|
    page.title = title
    page.subtitle = subtitle
    page.body_markdown = if slug == "privacy"
      "This site stores a subscription email only when you choose to subscribe. Public page views are counted without cookies. IP addresses are converted to daily rotating hashes and are not stored directly."
    else
      "[Editable placeholder] Add this page's content here."
    end
  end
end
