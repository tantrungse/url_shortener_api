Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post :encode, to: 'urls#encode'
    end
  end
end
