class Errors
  def initialize
    @errors = Mutations::ErrorHash.new
  end


  def present?
    @errors.present?
  end

  def to_s
    inspect
  end

  def inspect
    @errors.inspect
  end

  def add errors
    @errors.merge!(errors) if errors.present?
  end

  def css(key)
    "error" if error_for(key).present?
  end


  def error_for(key)
    key = key.to_s
    @errors[key] || @errors[key.to_sym]
  end

  def message_for key
    error_for(key).message if error_for(key).present?
  end

  def formatted_message_for(key)
    error_message = message_for(key)
    %(<span class="error_description">#{error_message}</span>).html_safe if error_message.present?
  end

end
