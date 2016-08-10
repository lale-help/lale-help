module PageObject
  class Base

    include Capybara::DSL

    def initialize(attrs = {})
      self.attributes = attrs
    end

    def attributes=(attrs)
      attrs.each { |key, value| send("#{key}=", value) }
    end

    def attributes
      self.instance_values.symbolize_keys
    end

  end
end