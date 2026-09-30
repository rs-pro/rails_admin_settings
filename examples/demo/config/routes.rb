Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  get '/favicon.ico', to: ->(_env) { [204, {}, []] }
  root 'home#index'
end
