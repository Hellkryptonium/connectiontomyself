class PostsController < ApplicationController
  def index
    @posts = Post.published
  end

  def show
    @post = Post.published.find_by!(slug: params[:slug])
    @newer_post = Post.published.where("published_at > ?", @post.published_at).order(published_at: :asc).first
    @older_post = Post.published.where("published_at < ?", @post.published_at).first
  end

  def archive
    @posts_by_month = Post.published.group_by { |post| post.published_at.beginning_of_month }
  end

  def feed
    @posts = Post.published.limit(20)
    response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
  end
end
