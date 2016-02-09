class Presenter
  include ActiveSupport::Callbacks
  include Rails.application.routes.url_helpers

  include ActionView::Helpers::FormOptionsHelper
  include ActionView::Helpers::DateHelper

  class_attribute :proc_table
  class_attribute :presenter_table

  define_callbacks :initialize

  delegate :to_param, :model_name, :to_key, to: :object

  attr_reader :object, :context

  self.proc_table = HashWithIndifferentAccess.new
  self.presenter_table = HashWithIndifferentAccess.new

  def self.inherited subclass
    super
    subclass.proc_table = self.proc_table.dup
    subclass.presenter_table = self.presenter_table.dup
  end


  def self.let key, presenter=nil, &block
    block ||= proc {
      object.send(key.to_sym)
    }

    self.proc_table[key.to_sym]      = block
    self.presenter_table[key.to_sym] = presenter if presenter.present?

    define_method key.to_sym do
      _cache_or_run(key)
    end
  end

  def self.name_object name
    define_method name.to_sym do
      self.object()
    end
  end

  def initialize obj=nil, context=nil
    run_callbacks :initialize do
      @object, @context = obj, context
    end
  end

  alias_method :_, :object


  private

  def _cache_or_run key
    @_proc_cache ||= HashWithIndifferentAccess.new
    @_proc_cache[key] ||= _run(key)
  end

  def _run key
    Rails.logger.debug "[#{self.class}] running: #{key}"
    val = instance_eval(&self.proc_table[key]) if self.proc_table.has_key?(key)

    if val.present? && self.presenter_table[key].present?
      if val.is_a? Array
        val.map{ |i| self.presenter_table[key].new(i, self) }
      else
        self.presenter_table[key].new(val, self)
      end
    else
      val
    end
  end
end