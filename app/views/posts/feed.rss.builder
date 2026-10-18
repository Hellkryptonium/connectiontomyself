xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "connectiontomyself writings"
    xml.link root_url
    xml.description "A small personal corner of the internet."
    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link writing_url(post.slug)
        xml.guid writing_url(post.slug)
        xml.pubDate post.published_at.rfc2822
        xml.description post.excerpt.presence || strip_tags(MarkdownRenderer.call(post.body_markdown))
      end
    end
  end
end
