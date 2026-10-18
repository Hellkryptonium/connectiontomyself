require "test_helper"

class GuestbookEntryTest < ActiveSupport::TestCase
  test "requires a name and message" do
    entry = GuestbookEntry.new

    assert_not entry.valid?
    assert_includes entry.errors.attribute_names, :name
    assert_includes entry.errors.attribute_names, :message
  end
end
