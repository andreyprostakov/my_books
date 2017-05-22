# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170522110801) do

  create_table "authors", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_authors_on_name", unique: true
  end

  create_table "book_in_editions", force: :cascade do |t|
    t.integer "book_id",    null: false
    t.integer "edition_id", null: false
    t.string  "title"
    t.string  "translator"
    t.index ["book_id"], name: "index_book_in_editions_on_book_id"
    t.index ["edition_id"], name: "index_book_in_editions_on_edition_id"
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "edition_categories", force: :cascade do |t|
    t.string "code", null: false
    t.index ["code"], name: "index_edition_categories_on_code", unique: true
  end

  create_table "editions", force: :cascade do |t|
    t.string   "isbn"
    t.string   "title"
    t.text     "annotation"
    t.string   "editor"
    t.integer  "pages_count"
    t.string   "language_code"
    t.integer  "edition_category_id"
    t.integer  "publisher_id"
    t.integer  "publication_year",    default: 1999
    t.string   "cover"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",                default: false
    t.integer  "series_id"
    t.index ["edition_category_id"], name: "index_editions_on_edition_category_id"
    t.index ["publisher_id"], name: "index_editions_on_publisher_id"
    t.index ["series_id"], name: "index_editions_on_series_id"
  end

  create_table "m2m_book_authors", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "book_id",   null: false
    t.index ["author_id", "book_id"], name: "index_m2m_book_authors_on_author_id_and_book_id", unique: true
    t.index ["author_id"], name: "index_m2m_book_authors_on_author_id"
    t.index ["book_id"], name: "index_m2m_book_authors_on_book_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "series", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
