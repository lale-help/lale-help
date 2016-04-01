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

ActiveRecord::Schema.define(version: 20160401084433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state_province"
    t.string   "postal_code"
    t.string   "country"
    t.integer  "location_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "addresses", ["location_id"], name: "index_addresses_on_location_id", using: :btree

  create_table "circle_roles", id: :bigserial, force: :cascade do |t|
    t.integer  "role_type",            null: false
    t.integer  "user_id",    limit: 8, null: false
    t.integer  "circle_id",  limit: 8, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "name"
  end

  create_table "circles", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name",                                null: false
    t.integer  "language",            default: 0,     null: false
    t.integer  "address_id"
    t.boolean  "must_activate_users", default: false
  end

  create_table "comments", id: :bigserial, force: :cascade do |t|
    t.integer  "commenter_id", limit: 8, null: false
    t.integer  "task_id",      limit: 8, null: false
    t.string   "task_type",              null: false
    t.text     "body"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "comments", ["commenter_id"], name: "index_comments_on_commenter_id", using: :btree
  add_index "comments", ["task_type", "task_id"], name: "index_comments_on_task_type_and_task_id", using: :btree

  create_table "locations", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "geocode_query"
    t.float    "latitude"
    t.float    "longitude"
    t.json     "geocode_data"
    t.string   "timezone"
  end

  create_table "project_roles", force: :cascade do |t|
    t.integer  "role_type",            null: false
    t.integer  "user_id",    limit: 8, null: false
    t.integer  "project_id", limit: 8, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "working_group_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "supplies", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "working_group_id"
    t.integer  "location_id",      limit: 8, null: false
    t.date     "due_date"
    t.datetime "completed_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "project_id"
  end

  create_table "supply_roles", force: :cascade do |t|
    t.integer  "role_type",            null: false
    t.integer  "user_id",    limit: 8, null: false
    t.integer  "supply_id",  limit: 8, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "system_event_notification_deliveries", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "notification_id", limit: 8,             null: false
    t.integer  "method",                    default: 0, null: false
    t.string   "content"
  end

  create_table "system_event_notifications", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",         limit: 8, null: false
    t.integer  "system_event_id", limit: 8, null: false
  end

  create_table "system_events", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id",    limit: 8,             null: false
    t.string   "for_type"
    t.integer  "for_id",     limit: 8,             null: false
    t.integer  "action",               default: 0
  end

  create_table "task_location_assignments", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "task_id",     limit: 8,                 null: false
    t.integer  "location_id", limit: 8,                 null: false
    t.boolean  "primary",               default: false, null: false
  end

  create_table "task_roles", id: :bigserial, force: :cascade do |t|
    t.integer  "role_type",            null: false
    t.integer  "user_id",    limit: 8, null: false
    t.integer  "task_id",    limit: 8, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "task_skill_assignments", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "task_id",    limit: 8,                 null: false
    t.integer  "skill_id",   limit: 8,                 null: false
    t.boolean  "required",             default: false, null: false
  end

  create_table "task_skills", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "tasks", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "name",                                                null: false
    t.string   "description"
    t.integer  "working_group_id",         limit: 8,                  null: false
    t.datetime "completed_at"
    t.date     "due_date"
    t.integer  "volunteer_count_required"
    t.integer  "duration",                           default: 1
    t.string   "scheduled_time_type"
    t.string   "scheduled_time_start",               default: "0:00", null: false
    t.string   "scheduled_time_end",                 default: "0:00", null: false
    t.integer  "project_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "code",                      null: false
    t.integer  "token_type",                null: false
    t.boolean  "active",     default: true
    t.json     "context"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "user_identities", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",         limit: 8, null: false
    t.string   "email"
    t.string   "password_digest"
  end

  create_table "users", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "location_id",       limit: 8
    t.integer  "language",                    default: 0
    t.integer  "primary_circle_id", limit: 8
    t.boolean  "is_admin"
    t.boolean  "accept_terms"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.datetime "last_login"
    t.boolean  "public_profile"
    t.string   "about_me"
    t.integer  "address_id"
    t.integer  "status"
  end

  add_index "users", ["address_id"], name: "index_users_on_address_id", using: :btree

  create_table "working_group_roles", id: :bigserial, force: :cascade do |t|
    t.integer  "role_type",                  null: false
    t.integer  "user_id",          limit: 8, null: false
    t.integer  "working_group_id", limit: 8, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "working_groups", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "circle_id",   limit: 8,                 null: false
    t.string   "name",                                  null: false
    t.string   "description"
    t.boolean  "is_private",            default: false
  end

end
