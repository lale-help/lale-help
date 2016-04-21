class Form
  class_attribute :attributes

  def self.attribute name, type, opts={}
    opts[:name] = name
    opts[:type] = type
    opts[:required] = true unless opts.has_key?(:required)

    self.attributes ||= Array.new
    self.attributes << opts

    attr_writer name
    unless instance_methods.include?(name)
      define_method name do
        if defined?("@#{name}") && instance_variable_defined?("@#{name}")
          instance_variable_get("@#{name}")

        elsif opts[:default].is_a? Proc
          p = opts[:default]
          val = self.instance_eval(&p)
          instance_variable_set("@#{name}", val)
          val

        elsif primary_object.respond_to?(name)
          primary_object.send(name)
        end
      end
    end
  end

  def model_name
    if primary_object.present?
      primary_object.model_name
    else
      @model_name ||= ActiveModel::Name.new(::Form)
    end
  end

  def param_key
    if primary_object.present?
      primary_object.param_key
    else
      model_name.param_key
    end
  end

  def to_key
    if primary_object.present?
      primary_object.to_key
    else
      []
    end
  end

  def to_model
    if primary_object.present?
      primary_object.to_model
    else
      self
    end
  end

  def persisted?
    if primary_object.present?
      primary_object.persisted?
    else
      false
    end
  end

  include Rails.application.routes.url_helpers
  def url
    if primary_object && primary_object.persisted?
      update_url
    else
      new_url
    end
  end

  def method
    if primary_object && primary_object.persisted?
      :patch
    else
      :post
    end
  end


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

  def self.run *args
    self.new(*args).submit
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

      # 'Task::Update::Submit' => 'Task::Update'
      form_class = subclass.to_s.split("::")[0..-2].join("::").constantize

      form_class.attributes.each do |a|
        # copy the required/optional options from the form to the mutation object
        action = a[:required] ? :required : :optional
        if action == :optional
          a[:empty] = true unless a.has_key?(:empty)
          a[:nils]  = true unless a.has_key?(:nils)
        end
        subclass.send(action) do
          send(a[:type], a[:name], a)
        end

      end
    end

    # # Instance methods
    # def initialize(*args)
    #   @raw_inputs = args.inject({}.with_indifferent_access) do |h, arg|
    #     raise ArgumentError.new("All arguments must be hashes") unless arg.is_a?(Hash)
    #     h.merge!(arg)
    #   end
    #
    #   # Do field-level validation / filtering:
    #   @inputs, @errors = self.input_filters.filter(@raw_inputs)
    #
    #   # Run a custom validation method if supplied:
    #   validate
    # end

  end
end


