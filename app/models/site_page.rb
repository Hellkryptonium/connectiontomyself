class SitePage < ApplicationRecord
  SLUGS = %w[home about now colophon uses privacy].freeze

  validates :slug, presence: true, uniqueness: true, inclusion: { in: SLUGS }
  validates :title, presence: true
  validates :body_markdown, presence: true
end
