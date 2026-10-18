# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_18_000006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_admin_users_on_lower_email", unique: true
  end

  create_table "guestbook_entries", force: :cascade do |t|
    t.string "name", null: false
    t.string "website_url"
    t.text "message", null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_guestbook_entries_on_approved"
  end

  create_table "links", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.text "description"
    t.string "category"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_links_on_position"
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "subject", null: false
    t.text "body_markdown", default: "", null: false
    t.string "status", default: "draft", null: false
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_at"], name: "index_newsletters_on_sent_at"
    t.index ["status"], name: "index_newsletters_on_status"
  end

  create_table "page_views", force: :cascade do |t|
    t.bigint "post_id"
    t.string "path", null: false
    t.string "ip_hash", null: false
    t.string "referrer_host"
    t.string "user_agent"
    t.string "country_code", limit: 2
    t.datetime "viewed_at", null: false
    t.index ["ip_hash", "viewed_at"], name: "index_page_views_on_ip_hash_and_viewed_at"
    t.index ["path"], name: "index_page_views_on_path"
    t.index ["post_id"], name: "index_page_views_on_post_id"
    t.index ["viewed_at"], name: "index_page_views_on_viewed_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.text "body_markdown", default: "", null: false
    t.string "status", default: "draft", null: false
    t.datetime "published_at"
    t.string "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "newsletter_sent_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["status", "published_at"], name: "index_posts_on_status_and_published_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "description", default: "", null: false
    t.text "body_markdown"
    t.string "status", default: "in progress", null: false
    t.string "technologies"
    t.string "external_url"
    t.date "started_on"
    t.date "ended_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "site_pages", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.text "body_markdown", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_site_pages_on_slug", unique: true
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email", null: false
    t.string "status", default: "pending", null: false
    t.string "confirmation_token", null: false
    t.datetime "confirmed_at"
    t.datetime "unsubscribed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_subscribers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_subscribers_on_email", unique: true
  end

  add_foreign_key "page_views", "posts"
end
