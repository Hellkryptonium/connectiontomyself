xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
  end
  [ about_url, now_url, colophon_url, uses_url, privacy_url, writings_url, archive_url, projects_url, links_url, guestbook_url, subscribe_url ].each do |url|
    xml.url { xml.loc url }
  end
  @pages.each do |page|
    xml.url do
      xml.loc page.slug == "home" ? root_url : public_send("#{page.slug}_url")
      xml.lastmod page.updated_at.utc.iso8601
    end
  end
  @posts.each do |post|
    xml.url do
      xml.loc writing_url(post.slug)
      xml.lastmod post.updated_at.utc.iso8601
    end
  end
  @projects.each do |project|
    xml.url do
      xml.loc project_url(project.slug)
      xml.lastmod project.updated_at.utc.iso8601
    end
  end
end
