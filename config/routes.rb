Rails.application.routes.draw do

  devise_for :parents
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users

  devise_for :teachers, controllers:{
                         sessions: 'teachers/sessions',
                         registrations: 'teachers/registrations',
                         passwords: 'teachers/passwords',
                         invitations: 'teachers/invitations'
  }
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
