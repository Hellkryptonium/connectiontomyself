class CreateNewsletters < ActiveRecord::Migration[8.1]
  def change
    create_table :newsletters do |t|
      t.string :subject, null: false
      t.text :body_markdown, null: false, default: ""
      t.string :status, null: false, default: "draft"
      t.datetime :sent_at
      t.timestamps
    end

    add_index :newsletters, :status
    add_index :newsletters, :sent_at
  end
end
