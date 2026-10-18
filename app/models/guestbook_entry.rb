class GuestbookEntry < ApplicationRecord
  validates :name, presence: true, length: { maximum: 80 }
  validates :message, presence: true, length: { maximum: 2_000 }
  validates :website_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  scope :approved, -> { where(approved: true).order(created_at: :desc) }
end
