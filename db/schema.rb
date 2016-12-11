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

ActiveRecord::Schema.define(version: 20161208210438) do

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
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
    t.string   "author",     null: false
  end

  create_table "editions", force: :cascade do |t|
    t.string  "isbn",          null: false
    t.string  "title"
    t.text    "annotation"
    t.string  "cover_url"
    t.string  "editor"
    t.integer "pages_count"
    t.string  "language_code"
  end

  create_table "m2m_book_authors", force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "book_id",   null: false
    t.index ["author_id"], name: "index_m2m_book_authors_on_author_id"
    t.index ["book_id"], name: "index_m2m_book_authors_on_book_id"
  end

end
