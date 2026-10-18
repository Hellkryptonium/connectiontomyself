require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "generates a human-readable slug" do
    post = Post.new(title: "A Note About the Web", body_markdown: "Hello")
    assert post.valid?
    assert_equal "a-note-about-the-web", post.slug
  end

  test "published scope excludes drafts" do
    draft = Post.create!(title: "Draft", body_markdown: "Private")
    published = Post.create!(title: "Published", body_markdown: "Public", status: "published", published_at: 1.hour.ago)

    assert_not_includes Post.published, draft
    assert_includes Post.published, published
  end
end
