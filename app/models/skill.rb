class Skill < ActiveRecord::Base

  CATEGORIES = %w(language qualification capability)

  has_many :skill_assignments, dependent: :destroy

  validates :key, presence: true, uniqueness: { scope: :category }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  def name
    I18n.t(key, scope: "skills.#{category}")
  end

  # private

  # FIXME only use the skill table to get defaults
  # move YAML / init table to a rake task
  def self.defaults
    @default_skills ||= begin 
      yml = YAML.load_file(Rails.root.join('config/default_skills.yml'))
      yml.inject({}) do |hash, (category, keys)| 
        hash[category] = keys.map { |key| find_or_create_by!(category: category, key: key, default: true) }
        hash
      end
    end
  end

end
