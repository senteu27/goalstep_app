Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

   root "goals#index"
   resources :goals
   resources :min_goals, only: [:update]
end
