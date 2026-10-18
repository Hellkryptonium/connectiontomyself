class PageView < ApplicationRecord
  belongs_to :post, optional: true

  validates :path, :ip_hash, :viewed_at, presence: true

  scope :recent, -> { where(viewed_at: 30.days.ago..).order(viewed_at: :desc) }
  scope :unique_visitors, -> { distinct.count(:ip_hash) }
end
