module Backdoor
  extend ActiveSupport::Concern

  included do
    prepend_before_action :auto_login_user
  end

  def auto_login_user
    if params[:as].present?
      user = User.find_by(id: params[:as])
      login(user) if user.present?
    end
  end
end

RSpec.configure do |config|
  config.before :suite do
    ApplicationController.include Backdoor
  end
end
