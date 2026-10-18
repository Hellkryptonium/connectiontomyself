class Post < ApplicationRecord
  STATUSES = %w[draft published].freeze

  validates :title, presence: true, length: { maximum: 180 }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :body_markdown, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :published_posts_have_publication_date

  scope :published, -> { where(status: "published").where.not(published_at: nil).where("published_at <= ?", Time.current).order(published_at: :desc) }
  scope :drafts, -> { where(status: "draft").order(updated_at: :desc) }

  before_validation :set_slug, if: -> { slug.blank? && title.present? }

  def publish!
    update!(status: "published", published_at: published_at || Time.current)
  end

  def unpublish!
    update!(status: "draft", published_at: nil)
  end

  def newsletter_sent?
    newsletter_sent_at.present?
  end

  def reading_time
    [ (body_markdown.to_s.split.size / 200.0).ceil, 1 ].max
  end

  private

  def set_slug
    self.slug = title.parameterize
  end

  def published_posts_have_publication_date
    return unless status == "published" && published_at.blank?

    errors.add(:published_at, "must be set for published posts")
  end
end
