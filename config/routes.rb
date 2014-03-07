RailsWebConsole::Engine.routes.draw do
  root to: 'console#index'
  post 'run' => 'console#run', as: :run
end
