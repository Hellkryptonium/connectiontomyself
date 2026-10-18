class CreateGuestbookAndSubscribers < ActiveRecord::Migration[8.1]
  def change
    create_table :guestbook_entries do |t|
      t.string :name, null: false
      t.string :website_url
      t.text :message, null: false
      t.boolean :approved, null: false, default: false
      t.timestamps
    end
    add_index :guestbook_entries, :approved

    create_table :subscribers do |t|
      t.string :email, null: false
      t.string :status, null: false, default: "pending"
      t.string :confirmation_token, null: false
      t.datetime :confirmed_at
      t.datetime :unsubscribed_at
      t.timestamps
    end
    add_index :subscribers, :email, unique: true
    add_index :subscribers, :confirmation_token, unique: true
  end
end
