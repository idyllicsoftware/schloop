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

ActiveRecord::Schema.define(version: 20161102071541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "name"
    t.integer  "sub_type"
    t.string   "original_filename"
    t.integer  "file_size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "grade_id"
  end

  add_index "divisions", ["grade_id"], name: "index_divisions_on_grade_id", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parents", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "first_name",                          null: false
    t.text     "last_name",                           null: false
    t.text     "guardian_type",                       null: false
  end

  add_index "parents", ["email"], name: "index_parents_on_email", unique: true, using: :btree
  add_index "parents", ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true, using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.text     "flags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "role_permissions", ["permission_id"], name: "index_role_permissions_on_permission_id", using: :btree
  add_index "role_permissions", ["role_id"], name: "index_role_permissions_on_role_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "role_map"
    t.boolean  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",               null: false
    t.text     "address",            null: false
    t.string   "zip_code",           null: false
    t.string   "phone1",             null: false
    t.string   "phone2"
    t.string   "website",            null: false
    t.integer  "school_director_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "code",               null: false
    t.string   "board"
    t.string   "principal_name"
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.string   "subject_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "grade_id"
  end

  add_index "subjects", ["grade_id"], name: "index_subjects_on_grade_id", using: :btree

  create_table "teachers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "school_id"
    t.string   "token"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true, using: :btree
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree
  add_index "teachers", ["token"], name: "index_teachers_on_token", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true, using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,             null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "type",                   default: "SchoolAdmin", null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "work_number"
    t.string   "cell_number"
    t.string   "user_token"
    t.integer  "school_id"
    t.string   "principal_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_token"], name: "index_users_on_user_token", using: :btree

  add_foreign_key "divisions", "grades"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "subjects", "grades"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
