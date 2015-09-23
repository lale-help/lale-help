class InitialSchema < ActiveRecord::Migration
  def change
    # Volunteer ---------------------------------------------------------------
    create_model :volunteers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
    end


    # Feedback ----------------------------------------------------------------
    create_model :volunteer_feedbacks do |t|
      t.long_integer :volunteer_id
      t.integer :rating
      t.text :comment
    end


    # Circles -----------------------------------------------------------------
    create_model :circles do |t|
      t.string :name, null: false
      t.long_integer :location_id
      t.long_integer :admin_id
    end

    create_model :working_groups do |t|
      t.long_integer :circle_id
      t.string :name, null: false
    end


    # Tasks -------------------------------------------------------------------
    create_model :tasks do |t|
      t.string :name, null: false
      t.string :description

      t.long_integer :working_group_id
      t.long_integer :discussion_id, null: true
    end

    create_model :task_skills do |t|
      t.string :name
    end

    create_model :task_skill_assignments do |t|
      t.long_integer :task_id
      t.long_integer :skill_id

      t.boolean :required, default: false, null: false
    end

    create_model :task_volunteer_assignments do |t|
      t.long_integer :task_id
      t.long_integer :volunteer_id
      t.boolean :organizer, default: false, null: false
    end

    create_model :task_location_assignments do |t|
      t.long_integer :task_id
      t.long_integer :location_id
      t.boolean :primary, default: false, null: false
    end


    # Discussions -------------------------------------------------------------
    create_model :discussions do |t|
      t.string :name, null: false
      t.long_integer :working_group_id
    end

    create_model :discussion_messages do |t|
      t.text :content, null: false
      t.long_integer :discussion_id
      t.long_integer :volunteer_id
    end

    create_model :discussion_volunteer_watchings do |t|
      t.long_integer :volunteer_id
      t.long_integer :discussion_id
    end


    # Locations ---------------------------------------------------------------
    create_model :locations do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
    end


    # System Events -----------------------------------------------------------
    create_model :system_events do |t|
      t.long_integer :volunteer_id

      t.string       :for_type
      t.long_integer :for_id

      t.integer       :action, default: 0
    end

    create_model :system_event_notifications do |t|
      t.long_integer :volunteer_id
      t.long_integer :system_event_id
    end

    create_model :system_event_notification_deliveries do |t|
      t.long_integer :notification_id
      t.integer :method, default: 0, null: false
      t.string :content
    end
  end



  def create_model name
    create_table name do |table|
      table.extend LongInteger
      table.timestamps null: false
      yield table
    end
    change_column name, :id, :integer, limit: 8
  end

  module LongInteger
    def long_integer name, opts={}
      opts = {limit: 8, null: false}.merge(opts)
      integer name, opts
    end
  end
end
