class CalendarLeafCell < ::ViewModel

  def show
    template = @options[:with_icon] ? :show_with_icon : :show
    render template
  end

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

  def icon
    "#{@options[:with_icon]}-icon"
  end

end
