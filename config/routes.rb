Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :encode, to: 'urls#encode'
      get :decode, to: 'urls#decode'
    end
  end
end
