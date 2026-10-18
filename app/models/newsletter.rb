class Newsletter < ApplicationRecord
  STATUSES = %w[draft sent].freeze

  validates :subject, presence: true, length: { maximum: 180 }
  validates :body_markdown, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :sent_newsletters_have_timestamp

  scope :recent, -> { order(updated_at: :desc) }

  def sent?
    status == "sent" || sent_at.present?
  end

  private

  def sent_newsletters_have_timestamp
    return unless status == "sent" && sent_at.blank?

    errors.add(:sent_at, "must be set for sent newsletters")
  end
end
