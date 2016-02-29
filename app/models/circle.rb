class Circle < ActiveRecord::Base
  attr_accessor :location_text

  has_many :roles
  has_many :users,      ->{ distinct }, through: :roles

  has_many :admins,     ->{ Circle::Role.send('circle.admin')     }, through: :roles, source: :user
  has_many :officials,  ->{ Circle::Role.send('circle.official')  }, through: :roles, source: :user
  has_many :volunteers, ->{ Circle::Role.send('circle.volunteer') }, through: :roles, source: :user
  has_many :leadership, ->{ Circle::Role.leadership }, through: :roles, source: :user

  has_many :working_groups, -> { order('lower(working_groups.name) ASC') }
  has_many :tasks, through: :working_groups
  has_many :supplies, through: :working_groups

  belongs_to :location
  belongs_to :address, autosave: true


  # Validations
  validates :name, presence: true
  validates :address, presence: true


  # Hooks
  after_initialize :build_association_defaults

  enum language: [:en, :de, :fr]

  def user_count
    users.count
  end

  def open_task_count
    tasks.count
  end

  def comment_average
    @comment_average  ||= begin
      recent_tasks = tasks.where("tasks.updated_at > ?", 1.month.ago)

      recent_task_count    = recent_tasks.count
      recent_comment_count = recent_tasks.joins(:comments).count

      if recent_task_count > 0
        recent_comment_count / recent_task_count
      else
        0
      end
    end
  end


  private

  def build_association_defaults
    build_address unless address.present?
  end
end
