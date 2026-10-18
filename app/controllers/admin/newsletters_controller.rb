class Admin::NewslettersController < Admin::BaseController
  before_action :set_newsletter, only: %i[edit update destroy send_newsletter]

  def index
    @newsletters = Newsletter.recent
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)
    if @newsletter.save
      redirect_to admin_newsletters_path, notice: "Newsletter draft saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @newsletter.update(newsletter_params)
      redirect_to admin_newsletters_path, notice: "Newsletter draft updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def send_newsletter
    if @newsletter.sent?
      redirect_to admin_newsletters_path, alert: "This newsletter was already sent."
    elsif !NewsletterDelivery.configured?
      redirect_to admin_newsletters_path, alert: "Configure Resend before sending newsletters."
    else
      SendNewsletterJob.perform_later(@newsletter.id)
      redirect_to admin_newsletters_path, notice: "Newsletter queued for active subscribers."
    end
  end

  def destroy
    @newsletter.destroy!
    redirect_to admin_newsletters_path, notice: "Newsletter deleted."
  end

  private

  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  def newsletter_params
    params.require(:newsletter).permit(:subject, :body_markdown)
  end
end
