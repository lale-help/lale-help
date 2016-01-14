class Circle::RolesController < ApplicationController
  include HasCircle

  def create
    authorize! :manage, current_circle

    current_circle.roles.create role_params

    redirect_to roles_circle_admin_path(current_circle)
  end

  def destroy
    authorize! :manage, current_circle

    role = current_circle.roles.find(params[:id])
    role.destroy

    redirect_to roles_circle_admin_path(current_circle)
  end

  private
  def role_params
    params[:circle_role].permit(:name, :role_type, :user_id)
  end

end