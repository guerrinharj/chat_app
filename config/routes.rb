Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/usuarios', to: 'usuarios#create'
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end
  end
end
