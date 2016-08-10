module PageObject
  class Base

    include Capybara::DSL

    def initialize(attrs = {})
      attrs.each { |key, value| send("#{key}=", value) }
    end

  end
end