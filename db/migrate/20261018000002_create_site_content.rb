class CreateSiteContent < ActiveRecord::Migration[8.1]
  def change
    create_table :site_pages do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :subtitle
      t.text :body_markdown, null: false, default: ""
      t.timestamps
    end
    add_index :site_pages, :slug, unique: true

    create_table :projects do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false, default: ""
      t.text :body_markdown
      t.string :status, null: false, default: "in progress"
      t.string :technologies
      t.string :external_url
      t.date :started_on
      t.date :ended_on
      t.timestamps
    end
    add_index :projects, :slug, unique: true

    create_table :links do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :description
      t.string :category
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :links, :position
  end
end
