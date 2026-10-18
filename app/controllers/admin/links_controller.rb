class Admin::LinksController < Admin::BaseController
  before_action :set_link, only: %i[edit update destroy]

  def index
    @links = Link.ordered
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to admin_links_path, notice: "Link saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to admin_links_path, notice: "Link updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy!
    redirect_to admin_links_path, notice: "Link removed."
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:title, :url, :description, :category, :position)
  end
end
