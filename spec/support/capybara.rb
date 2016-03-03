require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.server do |app, port|
  Rack::Handler::Unicorn.run app, Port: port
end


module CapybaraExtension
  def drag_by(right_by, down_by)
    base.drag_by(right_by, down_by)
  end
end

::Capybara::Node::Element.send :include, CapybaraExtension