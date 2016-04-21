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

ActiveRecord::Schema.define(version: 20160421142223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "filers", id: false, force: :cascade do |t|
    t.integer "cik",          null: false
    t.string  "name"
    t.string  "sic"
    t.string  "countryba"
    t.string  "stprba"
    t.string  "cityba"
    t.string  "zipba"
    t.string  "bas1"
    t.string  "bas2"
    t.string  "baph"
    t.string  "countryma"
    t.string  "stprma"
    t.string  "cityma"
    t.string  "zipma"
    t.string  "mas1"
    t.string  "mas2"
    t.string  "countryinc"
    t.string  "stprinc"
    t.integer "ein"
    t.string  "former"
    t.string  "symbol"
    t.string  "changedd"
    t.string  "afs"
    t.boolean "wksi"
    t.string  "fye"
    t.date    "period"
    t.string  "displayname"
    t.string  "exchange"
    t.string  "business"
    t.string  "incorporated"
    t.string  "irs"
  end

  add_index "filers", ["cik"], name: "index_filers_on_cik", unique: true, using: :btree

  create_table "financials", force: :cascade do |t|
  end

  create_table "nums", id: false, force: :cascade do |t|
    t.string  "adsh",     null: false
    t.string  "tag"
    t.string  "v"
    t.date    "dd"
    t.integer "qtrs"
    t.string  "uom"
    t.string  "cr"
    t.decimal "value"
    t.string  "footnote"
  end

  add_index "nums", ["adsh", "tag", "v", "dd", "qtrs", "uom", "cr"], name: "index_nums_on_adsh_and_tag_and_v_and_dd_and_qtrs_and_uom_and_cr", unique: true, using: :btree

  create_table "pres", force: :cascade do |t|
    t.string  "adsh",   null: false
    t.integer "report", null: false
    t.integer "line",   null: false
    t.string  "stmt"
    t.boolean "inpth"
    t.string  "rfile"
    t.string  "tag"
    t.string  "v"
    t.string  "plabel"
  end

  add_index "pres", ["adsh", "report", "line"], name: "index_pres_on_adsh_and_report_and_line", unique: true, using: :btree

  create_table "sics", force: :cascade do |t|
    t.integer "sic",           null: false
    t.string  "sic_descrip"
    t.integer "naics"
    t.string  "naics_descrip"
  end

  create_table "stocks", id: false, force: :cascade do |t|
    t.integer "cik",          null: false
    t.string  "ticker"
    t.string  "name"
    t.string  "exchange"
    t.string  "sic"
    t.string  "business"
    t.string  "incorporated"
    t.string  "irs"
  end

  add_index "stocks", ["cik"], name: "index_stocks_on_cik", using: :btree

  create_table "subs", id: false, force: :cascade do |t|
    t.string   "adsh",       null: false
    t.integer  "cik",        null: false
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
    t.string   "symbol"
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
  end

  add_index "subs", ["adsh"], name: "index_subs_on_adsh", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "tag",      null: false
    t.string  "v",        null: false
    t.boolean "custom"
    t.boolean "abstract"
    t.string  "datatype"
    t.string  "iord"
    t.string  "crdr"
    t.text    "tlabel"
    t.text    "doc"
  end

  add_index "tags", ["v", "tag"], name: "index_tags_on_v_and_tag", unique: true, using: :btree

  create_table "xbrls", force: :cascade do |t|
    t.integer "cik"
    t.string  "companyname"
    t.string  "formtype"
    t.date    "datefiled"
    t.string  "filename"
  end

end
