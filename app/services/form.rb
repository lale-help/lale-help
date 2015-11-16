class Form
  class_attribute :attributes

  def self.attribute name, type, opts={}
    opts[:name] = name
    opts[:type] = type
    opts[:required] = true unless opts.has_key?(:required)

    self.attributes ||= Array.new
    self.attributes << opts

    attr_writer name
    define_method name do
      if defined?("@#{name}") && instance_variable_get("@#{name}").present?
        instance_variable_get("@#{name}")

      elsif opts[:default].is_a? Proc
        p = opts[:default]
        self.instance_eval(&p)

      elsif primary_object.respond_to?(name)
        primary_object.send(name)
      end
    end
  end

  delegate :model_name, :param_key, :to_key, :to_model, to: :primary_object

  def initialize *args
    args.each do |arg|
      arg = arg.attributes if arg.respond_to?(:attributes)
      arg.each do |key, val|
        method = "#{key}=".to_sym
        if self.respond_to? method
          send(method, val)
        end
      end
    end
  end

  def primary_object
    a = self.class.attributes.find{|a| a[:primary] }
    if a.present?
      send(a[:name])
    end
  end


  def attributes
    self.class.attributes.each_with_object(Hash.new) do |a, hash|
      hash[a[:name]] = send(a[:name])
    end
  end


  def submit_class
    self.class::Submit
  end

  def submit
    submit_class.run(attributes).tap do |outcome|
      unless outcome.success?
        Rails.logger.error [
          "Failed to submit #{self.class}",
          "Class Attrs: #{self.class.attributes}",
          "Submit class: #{submit_class}",
          "attributes: #{attributes}",
          "errors: #{outcome.errors.symbolic}"
        ].join(?\n)
      end
    end
  end

  class Submit < Mutations::Command
    def self.inherited(subclass)
      form_class = subclass.to_s.split("::")[0..-2].join("::").constantize

      form_class.attributes.each do |a|
        action = a[:required] ? :required : :optional
        subclass.send(action) do
          send(a[:type], a[:name], a)
        end

      end
    end
  end
end


