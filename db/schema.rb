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

ActiveRecord::Schema.define(version: 20140809153636) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "history_id"
    t.string   "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["history_id"], name: "index_comments_on_history_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "histories", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "evented_at"
    t.integer  "user_id"
  end

  create_table "history_histories", force: true do |t|
    t.integer  "history_id"
    t.integer  "referencing_history_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_histories", ["history_id"], name: "index_history_histories_on_history_id"
  add_index "history_histories", ["referencing_history_id"], name: "index_history_histories_on_referencing_history_id"

  create_table "history_images", force: true do |t|
    t.integer  "history_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "image"
  end

  add_index "history_images", ["history_id"], name: "index_history_images_on_history_id"

  create_table "history_todos", force: true do |t|
    t.integer  "history_id"
    t.integer  "todo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_todos", ["history_id"], name: "index_history_todos_on_history_id"
  add_index "history_todos", ["todo_id"], name: "index_history_todos_on_todo_id"

  create_table "history_users", force: true do |t|
    t.integer  "assigned_history_id"
    t.integer  "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_users", ["assigned_history_id"], name: "index_history_users_on_assigned_history_id"
  add_index "history_users", ["assignee_id"], name: "index_history_users_on_assignee_id"

  create_table "project_users", force: true do |t|
    t.integer  "assigned_project_id"
    t.integer  "assignee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_users", ["assigned_project_id"], name: "index_project_users_on_assigned_project_id"
  add_index "project_users", ["assignee_id"], name: "index_project_users_on_assignee_id"

  create_table "projects", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "todos", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "color"
    t.datetime "duedate"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
