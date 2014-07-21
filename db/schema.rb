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

ActiveRecord::Schema.define(version: 20140721074133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lessons", force: true do |t|
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirmed",  default: false
  end

  add_index "lessons", ["student_id", "starts_at"], name: "index_lessons_on_student_id_and_starts_at", unique: true, using: :btree
  add_index "lessons", ["student_id"], name: "index_lessons_on_student_id", using: :btree
  add_index "lessons", ["teacher_id", "starts_at"], name: "index_lessons_on_teacher_id_and_starts_at", unique: true, using: :btree
  add_index "lessons", ["teacher_id"], name: "index_lessons_on_teacher_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "image"
    t.text     "content"
    t.boolean  "dismissed",  default: false
    t.datetime "appear_at"
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "author"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
