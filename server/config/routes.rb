Rails.application.routes.draw do
  match '*path', controller: 'application', action: 'options', constraints: {
    method: 'OPTIONS'
  }, via: [:options]

  namespace :pages, path: '/' do
    get :dashboard
  end
end
