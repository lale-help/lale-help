class Project < ActiveRecord:Base

  # 
  # a project has 1-n admins
  # 
  has_many :roles
  has_many :users,      ->{ distinct }, through: :roles
  has_many :admins,     ->{ Project::Role.send('project.admin') }, through: :roles, source: :user

  #
  # a project is always inside a working group
  #
  belongs_to :working_group

  #
  # volunteers are always sourced from the project's working group
  # DISCUSS: do this outside
  # DISCUSS: naming:
  #  - users
  #  - members
  #  - volunteers
  #
  def volunteers
    working_group.users
  end

  # a project can have tasks and supplies
  has_many :tasks
  has_many :supplies

end
