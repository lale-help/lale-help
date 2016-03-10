module Backdoor
  extend ActiveSupport::Concern

  included do
    prepend_before_action :auto_login_user
  end

  def auto_login_user
    if params[:as].present?
      user = User.find_by(id: params[:as])
      success = login(user) if user.present?
      Rails.logger.info "Logged in user #{user.id} through Backdoor" if success
    end
  end
end

RSpec.configure do |config|
  config.before :suite do
    ApplicationController.include Backdoor
  end
end
