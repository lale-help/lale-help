ActiveAdmin.register User do

  member_action :become, method: :get do
    begin
      user = User.find(params[:id])
      login(user)
      redirect_to root_path
    rescue
      redirect_to :back, notice: "Unable to become user with id #{params[:id]}"
    end
  end

  action_item :become, only: :show do
    link_to 'Become this User', become_admin_user_path
  end

end
