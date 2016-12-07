class User < ActiveRecord::Base
  include Commentable

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'

  has_one :identity, dependent: :destroy

  belongs_to :location #DEPRECATED
  belongs_to :address, dependent: :destroy
  belongs_to :primary_circle, class_name: 'Circle'
  alias_method :circle, :primary_circle

  has_many :task_roles, class_name: 'Task::Role', dependent: :destroy
  has_many :tasks, ->{ distinct }, through: :task_roles

  has_many :supply_roles, class_name: 'Supply::Role', dependent: :destroy
  has_many :supplies, ->{ distinct }, through: :supply_roles

  has_many :circle_roles, class_name: 'Circle::Role', dependent: :destroy
  has_many :circle_volunteer_roles, ->{ where(role_type: Circle::Role.role_types['circle.volunteer']) }, class_name: 'Circle::Role'
  has_many :circle_admin_roles, ->{ where(role_type: Circle::Role.role_types['circle.admin']) }, class_name: 'Circle::Role'
  has_many :circles, ->{ distinct }, through: :circle_roles

  has_many :working_group_roles, class_name: 'WorkingGroup::Role', dependent: :destroy
  has_many :working_groups, ->{ distinct }, through: :working_group_roles

  has_many :project_roles, class_name: 'Project::Role', dependent: :destroy
  has_many :projects, ->{ distinct }, through: :project_roles

  has_many :comments_made, class_name: Comment, inverse_of: :commenter, foreign_key: 'commenter_id', dependent: :destroy

  enum language: [:en, :de, :fr]

  scope :asc_order, -> { order(:last_name) }

  alias_attribute :active_since, :created_at

  class << self

    def find_or_create_lale_bot!
      user_identity = User::Identity.find_or_create_by!(email: 'lale-bot@lale.help') do |identity|
        identity.password = SecureRandom.uuid
        identity.user = User.new(first_name: 'Lale', last_name: 'Bot')
      end
      user_identity.user
    end
  end

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

  def list_name
    "#{last_name}, #{first_name}"
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
    self.id == Comment::AutoComment.commenter.id
  end

end
