class SymbolSerializer
  def self.dump(obj)
    obj.to_s if obj.present?
  end

  def self.load(text)
    text.to_sym if text.present?
  end
end