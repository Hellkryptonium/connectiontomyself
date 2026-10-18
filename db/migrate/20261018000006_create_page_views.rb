class CreatePageViews < ActiveRecord::Migration[8.1]
  def change
    create_table :page_views do |t|
      t.references :post, foreign_key: true
      t.string :path, null: false
      t.string :ip_hash, null: false
      t.string :referrer_host
      t.string :user_agent
      t.string :country_code, limit: 2
      t.datetime :viewed_at, null: false
    end

    add_index :page_views, :viewed_at
    add_index :page_views, :path
    add_index :page_views, [ :ip_hash, :viewed_at ]
  end
end
