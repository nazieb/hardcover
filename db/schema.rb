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

ActiveRecord::Schema.define(version: 20150227154746) do

  create_table "jobs", force: true do |t|
    t.string   "service_job_id"
    t.string   "service_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repo_id"
    t.string   "repo_token"
    t.string   "branch"
    t.decimal  "coverage",       precision: 5, scale: 2
  end

  add_index "jobs", ["repo_id"], name: "index_jobs_on_repo_id", using: :btree

  create_table "repos", force: true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "repo_token"
    t.integer  "jobs_count", default: 0
  end

  create_table "source_files", force: true do |t|
    t.string   "name"
    t.text     "source",              limit: 2147483647
    t.text     "coverage"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "coverage_percentage",                    precision: 5, scale: 2
  end

  add_index "source_files", ["job_id"], name: "index_source_files_on_job_id", using: :btree

  create_table "user_repos", force: true do |t|
    t.integer "user_id"
    t.integer "repo_id"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
  end

end
