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

ActiveRecord::Schema.define(version: 20150224112119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: true do |t|
    t.integer  "user_id"
    t.string   "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
    t.string   "description"
    t.string   "stripe_id"
    t.string   "status"
  end

  add_index "charges", ["user_id"], name: "index_charges_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "lessons", force: true do |t|
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  add_index "lessons", ["starts_at", "student_id"], name: "index_lessons_on_starts_at_and_student_id", unique: true, using: :btree
  add_index "lessons", ["starts_at", "teacher_id"], name: "index_lessons_on_starts_at_and_teacher_id", unique: true, using: :btree
  add_index "lessons", ["teacher_id", "starts_at"], name: "index_lessons_on_teacher_id_and_starts_at", unique: true, using: :btree
  add_index "lessons", ["teacher_id"], name: "index_lessons_on_teacher_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "image"
    t.text     "content"
    t.boolean  "dismissed",  default: false
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
  end

  add_index "notifications", ["lesson_id"], name: "index_notifications_on_lesson_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.integer  "price"
    t.integer  "lessons"
    t.integer  "duration"
    t.integer  "expiry_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_webhooks", force: true do |t|
    t.string   "stripe_id"
    t.string   "stripe_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.boolean  "show_on_page"
    t.boolean  "show_in_dropdown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbr"
  end

  add_index "teachers", ["user_id"], name: "index_teachers_on_user_id", using: :btree

  create_table "user_settings", force: true do |t|
    t.integer  "user_id"
    t.boolean  "purchased_dudu"
    t.boolean  "receive_morning_emails"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "view_large_plans"
    t.integer  "dudu_expiry_timestamp"
  end

  add_index "user_settings", ["user_id"], name: "index_user_settings_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.integer  "role_id"
    t.integer  "lesson_count"
    t.string   "skypeid"
    t.integer  "timezone_offset"
    t.string   "stripe_id"
    t.string   "avatar"
    t.integer  "referred_by"
    t.integer  "total_lessons_bought"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["stripe_id"], name: "index_users_on_stripe_id", using: :btree

end
