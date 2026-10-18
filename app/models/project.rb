class Project < ApplicationRecord
  validates :title, :slug, :description, :status, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :external_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  before_validation :set_slug, if: -> { slug.blank? && title.present? }
  scope :recent, -> { order(started_on: :desc, created_at: :desc) }

  private

  def set_slug
    self.slug = title.parameterize
  end
end
