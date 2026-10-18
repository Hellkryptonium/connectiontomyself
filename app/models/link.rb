class Link < ApplicationRecord
  validates :title, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  scope :ordered, -> { order(:position, :title) }
end
