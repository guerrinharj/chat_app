Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/usuarios', to: 'usuarios#create'
      get '/usuarios/:id/confirmar', to: 'usuarios#confirmar', as: :confirmar_usuario

      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
    end
  end
end
