class SitemapController < ApplicationController
  def index
    @posts = Post.published
    @projects = Project.recent
    @pages = SitePage.where(slug: SitePage::SLUGS)
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
