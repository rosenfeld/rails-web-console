require_relative 'rails_web_console/engine'

RailsWebConsole::Engine.initializer 'rails_web_console.mount_default' do
  Rails.application.routes.prepend do
    mount RailsWebConsole::Engine => '/console'
  end
end
