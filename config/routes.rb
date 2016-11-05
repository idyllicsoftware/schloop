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
                         invitations: 'admin/teachers/invitations',
                         imports: 'admin/teachers/teacher_imports'
  }


  devise_for :parents, controllers:{
                         sessions: 'admin/parents/sessions',
                         registrations: 'admin/parents/registrations',
                         passwords: 'admin/parents/passwords',
                         invitations: 'admin/parents/invitations'
  }

  namespace :admin do

    resource :teachers do
      get "imports/new" => 'teachers/teacher_imports#new'
      post "imports" => 'teachers/teacher_imports#create'
    end
    resource :users do
    end
    
    resources :schools, only: [:show, :create, :index] do
      member do
        post :add_grade
      end
      collection do
        get :all
      end
    end

    resource :school_admins do
      get "new" => 'school_admins#new'
      post "new" => 'school_admins#create'
    end

    resource :parents do
      get "/dashboards/parents_dashboard" => 'parents/dashboards#parents_dashboard'
    end

  end

  namespace :api do
    namespace :v1 do
      post "/school_admin/register" => 'school_admin#register'
      post "/teacher/register" => 'teachers#register'
      post "/teacher/login" => 'teachers#login'
      post "/teacher/dashboard" => 'teachers#dashboard'
    end
  end
end
