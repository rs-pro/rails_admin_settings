Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'
  get '/favicon.ico', to: ->(_env) { [204, {}, []] }
  root to: redirect('/rails_admin/rails_admin_settings~setting')
end
