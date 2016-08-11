module PageObject

  class SupplyPage < PageObject::Base

    def has_name?(name)
      find('.task-header .title', text: name)
    end

    def has_description?(description)
      find('.task-header .description', text: description)
    end

    def has_location?(location)
      find(".item-details-table .location .details", text: location)
    end

    def has_due_date?(due_date)
      # FIXME use a named date format here, put it in the yml file.
      formatted_date = I18n.l(due_date, format: "%A %-d %B %Y")
      find(".item-details-table .due-date .details", text: formatted_date)
    end

  end
end