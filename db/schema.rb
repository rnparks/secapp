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

ActiveRecord::Schema.define(version: 20160404174907) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "nums", force: :cascade do |t|
    t.string   "adsh",       null: false
    t.string   "tag",        null: false
    t.string   "version",    null: false
    t.date     "ddate",      null: false
    t.integer  "qtrs",       null: false
    t.string   "uom",        null: false
    t.integer  "coreg"
    t.decimal  "value"
    t.string   "footnote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pres", force: :cascade do |t|
    t.string   "adsh",       null: false
    t.integer  "report",     null: false
    t.integer  "line",       null: false
    t.string   "stmt"
    t.boolean  "inpth"
    t.string   "rfile"
    t.string   "tag"
    t.string   "version"
    t.string   "plabel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subs", id: false, force: :cascade do |t|
    t.string   "adsh"
    t.integer  "cik"
    t.string   "name"
    t.integer  "sic"
    t.string   "countryba"
    t.string   "stprba"
    t.string   "cityba"
    t.string   "zipba"
    t.string   "bas1"
    t.string   "bas2"
    t.string   "baph"
    t.string   "countryma"
    t.string   "stprma"
    t.string   "cityma"
    t.string   "zipma"
    t.string   "mas1"
    t.string   "mas2"
    t.string   "countryinc"
    t.string   "stprinc"
    t.integer  "ein"
    t.string   "former"
    t.string   "changedd"
    t.string   "afs"
    t.boolean  "wksi"
    t.string   "fye"
    t.string   "form"
    t.date     "period"
    t.integer  "fy"
    t.string   "fp"
    t.date     "filed"
    t.datetime "accepted"
    t.boolean  "prevrpt"
    t.boolean  "detail"
    t.string   "instance"
    t.integer  "nciks"
    t.string   "aciks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subs", ["adsh"], name: "index_subs_on_adsh", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "tag",        null: false
    t.string   "version",    null: false
    t.boolean  "custom"
    t.boolean  "abstract"
    t.string   "datatype"
    t.string   "iord"
    t.string   "crdr"
    t.text     "tlabel"
    t.text     "doc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
