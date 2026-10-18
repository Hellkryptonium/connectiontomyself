class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: %i[edit update destroy publish unpublish]

  def index
    @posts = Post.order(updated_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to admin_root_path, notice: "Draft saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_root_path, notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def publish
    @post.publish!
    redirect_to admin_root_path, notice: "Post published."
  end

  def unpublish
    @post.unpublish!
    redirect_to admin_root_path, notice: "Post returned to draft."
  end

  def destroy
    @post.destroy!
    redirect_to admin_root_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :slug, :excerpt, :body_markdown, :meta_description)
  end
end
