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

ActiveRecord::Schema.define(version: 20161213133007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "teaches"
    t.string   "topic",                         null: false
    t.string   "title",                         null: false
    t.integer  "master_grade_id",               null: false
    t.integer  "master_subject_id",             null: false
    t.text     "details"
    t.text     "pre_requisite"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",            default: 0, null: false
  end

  create_table "activity_categories", force: :cascade do |t|
    t.integer  "activity_id", null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "activity_shares", force: :cascade do |t|
    t.integer  "activity_id", null: false
    t.integer  "school_id",   null: false
    t.integer  "teacher_id",  null: false
    t.integer  "grade_id",    null: false
    t.integer  "division_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "activity_shares", ["activity_id"], name: "index_activity_shares_on_activity_id", using: :btree
  add_index "activity_shares", ["grade_id", "division_id"], name: "index_activity_shares_on_grade_id_and_division_id", using: :btree
  add_index "activity_shares", ["school_id", "activity_id"], name: "index_activity_shares_on_school_id_and_activity_id", using: :btree
  add_index "activity_shares", ["school_id"], name: "index_activity_shares_on_school_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "name"
    t.string   "original_filename"
    t.integer  "file_size"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "sub_type",          default: 0, null: false
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string   "title",                          null: false
    t.text     "data",                           null: false
    t.integer  "data_type",                      null: false
    t.text     "caption",           default: "", null: false
    t.integer  "teacher_id",                     null: false
    t.integer  "topic_id",                       null: false
    t.string   "preview_image_url", default: "", null: false
    t.integer  "views",             default: 0,  null: false
    t.integer  "likes",             default: 0,  null: false
    t.integer  "grade_id",                       null: false
    t.integer  "subject_id",                     null: false
    t.integer  "school_id",                      null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "bookmarks", ["grade_id"], name: "index_bookmarks_on_grade_id", using: :btree
  add_index "bookmarks", ["school_id"], name: "index_bookmarks_on_school_id", using: :btree
  add_index "bookmarks", ["subject_id"], name: "index_bookmarks_on_subject_id", using: :btree
  add_index "bookmarks", ["teacher_id"], name: "index_bookmarks_on_teacher_id", using: :btree
  add_index "bookmarks", ["topic_id"], name: "index_bookmarks_on_topic_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "name_map",                  null: false
    t.integer  "category_type", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "categories", ["name_map"], name: "index_categories_on_name_map", using: :btree

  create_table "collaborations", force: :cascade do |t|
    t.integer  "bookmark_id",                        null: false
    t.string   "collaboration_message", default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "collaborations", ["bookmark_id"], name: "index_collaborations_on_bookmark_id", using: :btree

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

  create_table "followups", force: :cascade do |t|
    t.integer  "bookmark_id",                   null: false
    t.string   "followup_message", default: "", null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "followups", ["bookmark_id"], name: "index_followups_on_bookmark_id", using: :btree

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
    t.string   "name",                        null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "school_id"
    t.integer  "master_grade_id", default: 0, null: false
  end

  add_index "grades", ["school_id"], name: "index_grades_on_school_id", using: :btree

  create_table "master_grades", force: :cascade do |t|
    t.string   "name"
    t.string   "name_map",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "master_grades", ["name_map"], name: "index_master_grades_on_name_map", using: :btree

  create_table "master_subjects", force: :cascade do |t|
    t.string   "name"
    t.string   "name_map",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "master_subjects", ["name_map"], name: "index_master_subjects_on_name_map", using: :btree

  create_table "parent_details", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "school_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.string   "name",           null: false
    t.text     "address",        null: false
    t.string   "zip_code",       null: false
    t.string   "phone1",         null: false
    t.string   "phone2"
    t.string   "website",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "code",           null: false
    t.string   "board"
    t.string   "principal_name"
    t.string   "logo"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "grade_id"
    t.integer  "division_id"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "students", force: :cascade do |t|
    t.integer  "school_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "parent_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",                          null: false
    t.string   "subject_code"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "grade_id"
    t.integer  "master_subject_id", default: 0, null: false
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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "teachers", ["confirmation_token"], name: "index_teachers_on_confirmation_token", unique: true, using: :btree
  add_index "teachers", ["email"], name: "index_teachers_on_email", unique: true, using: :btree
  add_index "teachers", ["invitation_token"], name: "index_teachers_on_invitation_token", unique: true, using: :btree
  add_index "teachers", ["invitations_count"], name: "index_teachers_on_invitations_count", using: :btree
  add_index "teachers", ["invited_by_id"], name: "index_teachers_on_invited_by_id", using: :btree
  add_index "teachers", ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true, using: :btree
  add_index "teachers", ["token"], name: "index_teachers_on_token", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title",                                 null: false
    t.integer  "master_grade_id",                       null: false
    t.integer  "master_subject_id",                     null: false
    t.integer  "teacher_id",            default: -1
    t.boolean  "is_created_by_teacher", default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "topics", ["master_grade_id"], name: "index_topics_on_master_grade_id", using: :btree
  add_index "topics", ["master_subject_id"], name: "index_topics_on_master_subject_id", using: :btree
  add_index "topics", ["teacher_id"], name: "index_topics_on_teacher_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "role_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "entity_type"
    t.integer  "entity_id"
  end

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
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_token"], name: "index_users_on_user_token", using: :btree

  add_foreign_key "bookmarks", "grades"
  add_foreign_key "bookmarks", "schools"
  add_foreign_key "bookmarks", "subjects"
  add_foreign_key "bookmarks", "teachers"
  add_foreign_key "bookmarks", "topics"
  add_foreign_key "collaborations", "bookmarks"
  add_foreign_key "divisions", "grades"
  add_foreign_key "ecircular_recipients", "ecirculars"
  add_foreign_key "followups", "bookmarks"
  add_foreign_key "grade_teachers", "divisions"
  add_foreign_key "grade_teachers", "grades"
  add_foreign_key "grade_teachers", "subjects"
  add_foreign_key "grade_teachers", "teachers"
  add_foreign_key "grades", "schools"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "subjects", "grades"
  add_foreign_key "topics", "master_grades"
  add_foreign_key "topics", "master_subjects"
  add_foreign_key "topics", "teachers"
  add_foreign_key "user_roles", "roles"
end
