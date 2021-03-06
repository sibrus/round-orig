# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131013000806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: true do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "sort_name"
    t.integer  "artist_id"
    t.string   "art_file_name"
    t.string   "art_content_type"
    t.integer  "art_file_size"
    t.datetime "art_updated_at"
    t.boolean  "art_checked",      default: false, null: false
  end

  add_index "albums", ["name"], name: "index_albums_on_name", using: :btree

  create_table "artist_genres", id: false, force: true do |t|
    t.integer "artist_id"
    t.integer "genre_id"
  end

  add_index "artist_genres", ["artist_id"], name: "index_artist_genres_on_artist_id", using: :btree
  add_index "artist_genres", ["genre_id"], name: "index_artist_genres_on_genre_id", using: :btree

  create_table "artists", force: true do |t|
    t.string "name"
    t.string "display_name"
    t.string "sort_name"
  end

  add_index "artists", ["name"], name: "index_artists_on_name", using: :btree

  create_table "genres", force: true do |t|
    t.string "name"
    t.string "display_name"
  end

  add_index "genres", ["name"], name: "index_genres_on_name", using: :btree

  create_table "selections", force: true do |t|
    t.integer  "track_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", force: true do |t|
    t.string "name"
    t.text   "root_path"
    t.text   "path_fix"
  end

  create_table "tracks", force: true do |t|
    t.string  "itunes_id"
    t.text    "name"
    t.text    "display_name"
    t.text    "file"
    t.text    "sort_name"
    t.integer "track_number"
    t.integer "track_count"
    t.integer "year"
    t.integer "runtime"
    t.boolean "compilation"
    t.integer "album_artist_id"
    t.integer "album_id"
    t.integer "artist_id"
    t.integer "genre_id"
    t.integer "source_id"
  end

  add_index "tracks", ["name"], name: "index_tracks_on_name", using: :btree

end
