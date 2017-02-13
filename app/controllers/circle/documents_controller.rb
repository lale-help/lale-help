class Circle::DocumentsController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  before_action :ensure_logged_in
  before_action :set_back_path, only: [:index]

  def index
    authorize! :read, current_circle

    @circle_files = current_circle.files.select{ |f| can?(:read, f) }
    @circle_links = [] # current_circle.links.select{ |f| can?(:read, f) }
    
    @working_group_files = FileUpload.where(uploadable: current_circle.working_groups).select { |f| can?(:read, f) }
    @working_group_links = [] # links.select{ |f| can?(:read, f) }
    
    @project_files = FileUpload.where(uploadable: current_circle.projects).select { |f| can?(:read, f) }
    @project_links = [] # current_circle.links.select{ |f| can?(:read, f) }
  end
end
