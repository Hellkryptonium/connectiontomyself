class GuestbookEntriesController < ApplicationController
  def index
    @entries = GuestbookEntry.approved
    @entry = GuestbookEntry.new
  end

  def create
    if params[:website].present?
      redirect_to guestbook_path, notice: "Thanks for stopping by."
      return
    end

    @entry = GuestbookEntry.new(entry_params)
    if @entry.save
      redirect_to guestbook_path, notice: "Thanks. Your note is waiting for approval."
    else
      @entries = GuestbookEntry.approved
      render :index, status: :unprocessable_entity
    end
  end

  private

  def entry_params
    params.require(:guestbook_entry).permit(:name, :website_url, :message)
  end
end
