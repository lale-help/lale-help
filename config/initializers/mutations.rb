class I18nErrorMessageGenerator
  # key: the name of the field, eg, :email. Could be nil if it's an array element
  # error_symbol: the validation symbol, eg, :matches or :required
  # options:
  #  :index -- index of error if it's in an array
  def message(key, error_symbol, options = {})
    I18n.t("errors.#{key}.#{error_symbol}")
  end
end

Mutations.error_message_creator = I18nErrorMessageGenerator.new