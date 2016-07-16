class Skill

  attr_reader :category, :key
 
  def initialize(category:, key:)
    @category, @key = category, key
  end

  def name
    I18n.t(key, scope: "skills.#{category}")
  end

  def self.find_by_key(key)
    new(key: key, category: get_category(key))
  end

  def self.find_all_by_key(keys)
    keys.map { |key| self.find_by_key(key) }
  end

  private

  def self.defaults
    @default_skills ||= YAML.load_file(Rails.root.join('config/default_skills.yml'))
  end

  def self.get_category(key)
    self.category_lookup[key.to_s]
  end

  def self.category_lookup
    @category_lookup ||= begin
      defaults.inject({}) do |hash, (category, keys)|
        keys.each { |key| hash[key] = category }
        hash
      end
    end
  end
end
