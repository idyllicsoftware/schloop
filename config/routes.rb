Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  devise_for :users, controllers:{
                         sessions: 'admin/users/sessions',
                         registrations: 'admin/users/registrations',
                         passwords: 'admin/users/passwords',
                         invitations: 'admin/users/invitations'
  }


  devise_for :teachers, controllers:{
                         sessions: 'admin/teachers/sessions',
                         registrations: 'admin/teachers/registrations',
                         passwords: 'admin/teachers/passwords',
                         invitations: 'admin/teachers/invitations'
  }


  devise_for :parents, controllers:{
                         sessions: 'admin/parents/sessions',
                         registrations: 'admin/parents/registrations',
                         passwords: 'admin/parents/passwords',
                         invitations: 'admin/parents/invitations'
  }

  namespace :admin do
    resource :users do
    end

    resources :schools do
      member do
      end
      collection do
        get :all
      end

      resources :ecirculars do
      end

      resources :school_admins, only: [:index, :create, :update, :destroy], shallow: true do
      end

      resources :teachers, only: [:index, :create, :update, :destroy], shallow: true do

      end

      resources :grades, only: [:index, :create], shallow: true do
        resources :subjects,only: [:index, :create, :update, :destroy], shallow: true do

        end
        resources :divisions, only: [:index, :create, :update, :destroy], shallow: true do

        end
      end

    end

    resource :parents do
      get "/dashboards/parents_dashboard" => 'parents/dashboards#parents_dashboard'
    end

    resources :activities, only: [:index] do
      post :create_or_update
    end
  end

  namespace :api do
    namespace :v1 do
      post "/school_admin/register" => 'school_admin#register'
      post "/teacher/register" => 'teachers#register'
      post "/teacher/login" => 'teachers#login'
      post "/teacher/dashboard" => 'teachers#dashboard'
      post "/teacher/reset_password" => "teachers#reset_password"
      get "/teacher/profile" => "teachers#profile"
      post "/ecircular/tags" => "ecirculars#tags"
      post "/ecircular/create" => "ecirculars#create"
      get "/ecirculars" => "ecirculars#index"
    end
  end

end
