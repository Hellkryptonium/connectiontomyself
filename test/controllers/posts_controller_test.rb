require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published = Post.create!(title: "Public note", body_markdown: "Hello", status: "published", published_at: 1.hour.ago)
    @draft = Post.create!(title: "Private note", body_markdown: "Secret", slug: "private-note")
  end

  test "published posts appear in writings" do
    get writings_url

    assert_response :success
    assert_includes response.body, @published.title
    assert_not_includes response.body, @draft.title
  end

  test "draft posts are not accessible" do
    get writing_url(@draft.slug)

    assert_response :not_found
  end

  test "sitemap includes published posts but not drafts" do
    get sitemap_url, as: :xml

    assert_response :success
    assert_includes response.body, writing_url(@published.slug)
    assert_not_includes response.body, writing_url(@draft.slug)
  end
end
