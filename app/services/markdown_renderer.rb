class MarkdownRenderer
  ALLOWED_TAGS = %w[a blockquote code em h1 h2 h3 h4 li ol p pre strong ul].freeze
  ALLOWED_ATTRIBUTES = %w[href].freeze

  def self.call(markdown)
    html = CommonMarker.render_html(markdown.to_s, :DEFAULT)
    Rails::HTML5::SafeListSanitizer.new.sanitize(
      html,
      tags: ALLOWED_TAGS,
      attributes: ALLOWED_ATTRIBUTES
    ).html_safe
  end
end
