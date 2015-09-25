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

ActiveRecord::Schema.define(version: 20150925013521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "circles", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name",                  null: false
    t.integer  "location_id", limit: 8, null: false
    t.integer  "admin_id",    limit: 8, null: false
  end

  create_table "discussion_messages", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "content",                 null: false
    t.integer  "discussion_id", limit: 8, null: false
    t.integer  "volunteer_id",  limit: 8, null: false
  end

  create_table "discussion_volunteer_watchings", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "volunteer_id",  limit: 8, null: false
    t.integer  "discussion_id", limit: 8, null: false
  end

  create_table "discussions", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",                       null: false
    t.integer  "working_group_id", limit: 8, null: false
  end

  create_table "locations", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
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
    t.integer  "volunteer_id",    limit: 8, null: false
    t.integer  "system_event_id", limit: 8, null: false
  end

  create_table "system_events", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "volunteer_id", limit: 8,             null: false
    t.string   "for_type"
    t.integer  "for_id",       limit: 8,             null: false
    t.integer  "action",                 default: 0
  end

  create_table "task_location_assignments", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "task_id",     limit: 8,                 null: false
    t.integer  "location_id", limit: 8,                 null: false
    t.boolean  "primary",               default: false, null: false
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

  create_table "task_volunteer_assignments", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "task_id",      limit: 8,                 null: false
    t.integer  "volunteer_id", limit: 8,                 null: false
    t.boolean  "organizer",              default: false, null: false
  end

  create_table "tasks", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",                       null: false
    t.string   "description"
    t.integer  "working_group_id", limit: 8, null: false
    t.integer  "discussion_id",    limit: 8
    t.datetime "completed_at"
    t.date     "due_date"
  end

  create_table "volunteer_feedbacks", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "volunteer_id", limit: 8, null: false
    t.integer  "rating"
    t.text     "comment"
  end

  create_table "volunteer_identities", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "volunteer_id",    limit: 8, null: false
    t.string   "email"
    t.string   "password_digest"
  end

  create_table "volunteers", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
  end

  create_table "working_groups", id: :bigserial, force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "circle_id",  limit: 8, null: false
    t.string   "name",                 null: false
  end

end
