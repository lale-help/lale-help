module PageObject
  module Task
    class Form < PageObject::Page

      set_url '/circles/{circle_id}/tasks/new{?as}'

      element :title, 'main.form h2'

      include PageObject::IsForm

      private

      def next_page_object
        Page.new
      end
        
      def fill_form(inputs)
        # required fields
        fill_in "Name of the Task", with: inputs[:name]
        fill_in "Description of the Task", with: inputs[:description]
        fill_in "Place of task", with: inputs[:location]
        # optional fields
        select(inputs[:volunteer_count_required], from: 'Required number of volunteers') if inputs[:volunteer_count_required]
        select(inputs[:duration], from: 'Time Commitment')         if inputs[:duration]
        select(inputs[:due], from: 'Due')                          if inputs[:due]
        fill_date('#task_due_date_string', inputs[:due_date])      if inputs[:due_date]
        fill_in "End time", with: inputs[:due_time]                if inputs[:due_time]
        fill_date('#task_start_date_string', inputs[:start_date])  if inputs[:start_date]
        fill_in "Start time", with: inputs[:start_time]            if inputs[:start_time]
        select(inputs[:working_group_name], from: 'Working Group') if inputs[:working_group_name]
        select(inputs[:organizer_name], from: 'Organizer')         if inputs[:organizer_name]
        hide_open_datetimepickers
      end

      def fill_date(selector, date)
        formatted = date.strftime(I18n.t('circle.tasks.form.date_format'))
        find(selector).set(formatted)
      end

      def submit_button
        find(".submit-row input[type=submit]")
      end

      # close all date[time]pickers so we get a clean screenshot of the fields below
      def hide_open_datetimepickers
        sleep 0.2
        execute_script("$('.xd_datepicker, .xd_timepicker').datetimepicker('hide')")
      end

    end
  end
end