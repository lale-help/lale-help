class User < ActiveRecord::Base
  include Commentable

  # has_many :feedback

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'

  has_one :identity, dependent: :destroy

  belongs_to :location #DEPRECATED
  belongs_to :address, dependent: :destroy
  belongs_to :primary_circle, class_name: 'Circle'

  has_many :task_roles, class_name: 'Task::Role', dependent: :destroy
  has_many :tasks, ->{ distinct }, through: :task_roles

  has_many :supply_roles, class_name: 'Supply::Role', dependent: :destroy
  has_many :supplies, ->{ distinct }, through: :supply_roles

  has_many :circle_roles, class_name: 'Circle::Role', dependent: :destroy
  has_many :circles, ->{ distinct }, through: :circle_roles

  has_many :working_group_roles, class_name: 'WorkingGroup::Role', dependent: :destroy
  has_many :working_groups, ->{ distinct }, through: :working_group_roles

  has_many :project_roles, class_name: 'Project::Role', dependent: :destroy
  has_many :projects, ->{ distinct }, through: :project_roles

  has_many :comments_made, class_name: Comment, inverse_of: :commenter, foreign_key: 'commenter_id', dependent: :destroy

  enum language: [:en, :de, :fr]

  alias_attribute :active_since, :created_at

  def login_token
    @login_token ||= begin
      previous = Token.login.active.for_user_id(self.id).first
      if previous.present?
        previous
      else
        Token.login.active.create context: { user_id: self.id }
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def email
    identity.try :email
  end

  def tasks_for_circle circle
    task_assignments.where(circle: circle).tasks
  end

  def initials
    (first_name.first + last_name.first).upcase
  end

  def admin?
    self.is_admin
  end

  def public_profile?
    identity.try :public_profile
  end

  def active_in_circle?(circle)
    circle.has_active_user?(self)
  end

  def active_circles
    circles.select { |circle| circle.has_active_user?(self) }
  end

  def has_circles?
    !circles.empty?
  end

  def has_multiple_circles?
    circles.count > 1
  end

  def role_for_circle(circle)
    circle_roles.find_by(circle: circle)
  end

  def lale_bot?
    self.id == Task::Comments::Base.commenter.id
  end

end
