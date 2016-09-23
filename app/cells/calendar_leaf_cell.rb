class CalendarLeafCell < ::ViewModel

  # this is the default anyways.
  # def show
  #   render
  # end

  alias :date :model

  def attributes
    @options.slice(:class, :data)
  end

  private

  def month
    I18n.l(date, format: "%b").upcase
  end

  def day
    date.day
  end

  def week
    I18n.l(date, format: '%a')
  end

end
