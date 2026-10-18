class HomeController < ApplicationController
  def index
    @home_page = SitePage.find_by(slug: "home")
    @recent_posts = Post.published.limit(3)
    @projects = Project.recent.limit(3)
    @now_page = SitePage.find_by(slug: "now")
  end
end
