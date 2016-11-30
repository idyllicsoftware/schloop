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


  # devise_for :parents, controllers:{
  #                        sessions: 'admin/parents/sessions',
  #                        registrations: 'admin/parents/registrations',
  #                        passwords: 'admin/parents/passwords',
  #                        invitations: 'admin/parents/invitations'
  # }

  namespace :admin do
    resources :parent_imports, only: [:new, :create]
    resources :students
    resource :users

    namespace :teachers do
      resources :teacher_imports, only: [:create], shallow: true
    end

    resources :schools do
      collection do
        get :all
      end

      resources :ecirculars, only: [:create], shallow: true do
        collection do
          get :all
        end
      end

      resources :school_admins, only: [:index, :create, :update, :destroy], shallow: true do
      end

      resources :teachers, only: [:index, :create, :update, :destroy], shallow: true do
      end

      resources :grades, only: [:index, :create, :destroy], shallow: true do
        collection do
          get :grades_divisions
        end
        resources :subjects, only: [:index, :create, :update, :destroy], shallow: true do

        end
        resources :divisions, only: [:index, :create, :update, :destroy], shallow: true do

        end
      end

    end

    resource :parents do
      get "/dashboards/parents_dashboard" => 'parents/dashboards#parents_dashboard'
    end

    resources :activities, only: [:create, :show] do
      member do
        put :deactivate
      end
      collection do
        get :all
        post :upload_file
      end
    end
  end

  namespace :api do
    namespace :v1 do
      post "/school_admin/register" => 'school_admin#register'

      post "/teacher/register" => 'teachers#register'
      post "/teacher/login" => 'teachers#login'
      post "/teacher/dashboard" => 'teachers#dashboard'
      post "/teacher/reset_password" => "teachers#reset_password"
      get  "/teacher/profile" => "teachers#profile"

      post "/ecircular/tags" => "ecirculars#tags"
      post "/ecircular/create" => "ecirculars#create"
      get  "/ecirculars" => "ecirculars#index"
      post "/ecirculars" => "ecirculars#index"

      get  "/activities" => "activities#index"
      get  "/activity/categories" => "activities#get_categories"
    end
  end

end
