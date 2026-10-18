class Admin::GuestbookEntriesController < Admin::BaseController
  before_action :set_entry, only: %i[approve destroy]

  def index
    @entries = GuestbookEntry.order(approved: :asc, created_at: :desc)
  end

  def approve
    @entry.update!(approved: true)
    redirect_to admin_guestbook_entries_path, notice: "Entry approved."
  end

  def destroy
    @entry.destroy!
    redirect_to admin_guestbook_entries_path, notice: "Entry removed."
  end

  private

  def set_entry
    @entry = GuestbookEntry.find(params[:id])
  end
end
