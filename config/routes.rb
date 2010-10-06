Rails::Application.routes.draw do
  get 'console' => 'console#index'
  post 'console/run' => 'console#run'
end
