module HasFlash

  extend ActiveSupport::Concern

  private

  def set_flash(type, options = {})
    flash[type] = flash_msg_for(type, options)
  end

  def set_flash_now(type, options = {})
    flash.now[type] = flash_msg_for(type, options)
  end

  def flash_msg_for(type, options)
    msg_options = { scope: msg_scope }.merge(options)
    t(type, msg_options)
  end

  def msg_scope
    resource_name = controller_name.tableize.split('_').first
    "#{resource_name}.flash.#{action_name}"
  end

end
