require "test_helper"

class MarkdownRendererTest < ActiveSupport::TestCase
  test "renders markdown while removing scripts" do
    html = MarkdownRenderer.call("# Hello\n\n<script>alert(1)</script>")

    assert_includes html, "<h1>Hello</h1>"
    assert_not_includes html, "script"
  end
end
