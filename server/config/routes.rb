Rails.application.routes.draw do
  match '*path', controller: 'application', action: 'options', constraints: {
    method: 'OPTIONS'
  }, via: [:options]

  namespace :pages, path: '/' do
    get :dashboard
    get :historical_report, path: 'historical-report'
  end
end
