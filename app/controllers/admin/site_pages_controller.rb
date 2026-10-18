class Admin::SitePagesController < Admin::BaseController
  before_action :set_page, only: %i[edit update]

  def index
    @pages = SitePage.order(:slug)
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_site_pages_path, notice: "Page updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    @page = SitePage.find(params[:id])
  end

  def page_params
    params.require(:site_page).permit(:title, :subtitle, :body_markdown)
  end
end
