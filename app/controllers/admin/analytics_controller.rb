class Admin::AnalyticsController < Admin::BaseController
  def show
    recent_views = PageView.where(viewed_at: 30.days.ago..)
    @total_views = PageView.count
    @recent_views = recent_views.count
    @unique_visitors = recent_views.distinct.count(:ip_hash)
    @top_pages = recent_views.group(:path).order(Arel.sql("COUNT(*) DESC")).limit(10).count
    @top_articles = recent_views.where.not(post_id: nil).group(:post_id).order(Arel.sql("COUNT(*) DESC")).limit(10).count
    @article_names = Post.where(id: @top_articles.keys).index_by(&:id)
    @referrers = recent_views.where.not(referrer_host: nil).group(:referrer_host).order(Arel.sql("COUNT(*) DESC")).limit(10).count
    @countries = recent_views.where.not(country_code: nil).group(:country_code).order(Arel.sql("COUNT(*) DESC")).limit(10).count
  end
end
