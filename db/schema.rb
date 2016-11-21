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

ActiveRecord::Schema.define(version: 20161121131556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "teaches"
    t.string   "topic",         null: false
    t.string   "title",         null: false
    t.integer  "attachment_id"
    t.integer  "grade",         null: false
    t.integer  "subject",       null: false
    t.text     "details"
    t.text     "pre_requisite"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "activities", ["grade"], name: "index_activities_on_grade", using: :btree
  add_index "activities", ["subject"], name: "index_activities_on_subject", using: :btree

  create_table "activity_categories", force: :cascade do |t|
    t.integer  "activity_id", null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "name"
    t.string   "original_filename"
    t.integer  "file_size"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "name_map",      null: false
    t.integer  "category_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "content_categories", force: :cascade do |t|
    t.integer  "content_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string   "teaches"
    t.string   "topic",         null: false
    t.string   "title",         null: false
    t.integer  "attachment_id"
    t.integer  "grade",         null: false
    t.integer  "subject",       null: false
    t.integer  "category",      null: false
    t.text     "details"
    t.text     "pre_requisite"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "contents", ["category"], name: "index_contents_on_category", using: :btree
  add_index "contents", ["grade"], name: "index_contents_on_grade", using: :btree
  add_index "contents", ["subject"], name: "index_contents_on_subject", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "grade_id"
  end

  add_index "divisions", ["grade_id"], name: "index_divisions_on_grade_id", using: :btree

  create_table "ecircular_recipients", force: :cascade do |t|
    t.integer  "school_id"
    t.integer  "grade_id"
    t.integer  "division_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "ecircular_id"
  end

  add_index "ecircular_recipients", ["ecircular_id"], name: "index_ecircular_recipients_on_ecircular_id", using: :btree

  create_table "ecirculars", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "circular_tag"
    t.integer  "created_by_type"
    t.integer  "created_by_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "school_id"
  end

  create_table "grade_teachers", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "division_id"
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.integer  "grade_id"
  end

  add_index "grade_teachers", ["division_id"], name: "index_grade_teachers_on_division_id", using: :btree
  add_index "grade_teachers", ["grade_id"], name: "index_grade_teachers_on_grade_id", using: :btree
  add_index "grade_teachers", ["subject_id"], name: "index_grade_teachers_on_subject_id", using: :btree
  add_index "grade_teachers", ["teacher_id"], name: "index_grade_teachers_on_teacher_id", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "school_id"
  end

  add_index "grades", ["school_id"], name: "index_grades_on_school_id", using: :btree

  create_table "parents", force: :cascade do |t|
    t.string   "email",                  limit: 100, default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.text     "first_name",                                      null: false
    t.text     "last_name",                                       null: false
    t.text     "guardian_type",                                   null: false
  end

  add_index "parents", ["email"], name: "index_parents_on_email", unique: true, using: :btree
  add_index "parents", ["reset_password_token"], name: "index_parents_on_reset_password_token", unique: true, using: :btree

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
    t.string   "logo"
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",         null: false
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
    t.string   "cell_number"
  end

  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true, using: :btree
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree
  add_index "teachers", ["token"], name: "index_teachers_on_token", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_token"], name: "index_users_on_user_token", using: :btree

  add_foreign_key "divisions", "grades"
  add_foreign_key "ecircular_recipients", "ecirculars"
  add_foreign_key "grade_teachers", "divisions"
  add_foreign_key "grade_teachers", "grades"
  add_foreign_key "grade_teachers", "subjects"
  add_foreign_key "grade_teachers", "teachers"
  add_foreign_key "grades", "schools"
  add_foreign_key "subjects", "grades"
end
