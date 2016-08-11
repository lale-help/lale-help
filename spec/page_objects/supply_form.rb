module PageObject
  class SupplyForm < Form

    def next_page_object
      SupplyPage.new
    end
      
    private

    def fill_form(attributes)
      fill_in "Name of supply",  with: attributes[:name]
      fill_in "Description",     with: attributes[:description]
      fill_in "Due Date",        with: attributes[:due_date]
      fill_in "Location",        with: attributes[:location]
    end

    def submit_button
      button_label = "#{@action.to_s.capitalize} Supply"
      find("input[type=submit][value='#{button_label}']")
    end

  end
end