Rails.application.routes.draw do


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  require 'sidekiq/web'
  mount Sidekiq::Web, at: "/kiq"

  # You can have the root of your site routed with "root"
  root 'home#index'
  
  get 'privacy_policy' => 'home#privacy_policy'
  get 'terms' => 'home#terms'
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

    #post 'password_resets/create_for_teacher' => 'password_resets#create_for_teacher'
    #get 'password_resets/teacher_edit' => 'password_resets#teacher_edit'
    #patch 'password_resets/teacher_update' => 'password_resets#teacher_update'
    post '/password_resets/create' => 'password_resets#create'
    get 'password_resets/edit' => 'password_resets#edit'
    patch 'password_resets/update' => 'password_resets#update'
    get 'password_resets/parent_new' => 'password_resets#parent_new'
    post 'password_resets/create_for_parent' => 'password_resets#create_for_parent'
    get 'password_resets/parent_edit' => 'password_resets#parent_edit'
    patch 'password_resets/parent_update' => 'password_resets#parent_update'

  namespace :admin do
    resources :parent_imports, only: [:new, :create]
    resources :students, only: [:index, :update] do 
      collection do
        post :deactivate
      end
    end

    namespace :teachers do #teachers folder in admin
      resources :teacher_imports, only: [:create], shallow: true
      resources :dashboards do 
        collection do
         
        end

      end
      resources :bookmarks, only:[:create,:destroy] do 
        collection do
          get :get_bookmarks
          post :add_caption
          post :bookmark_like_or_view
        end
      end
      resources :topics do
        collection do
           get :get_topics
        end
      end
      resources :collaborations do
        collection do
          post :add_to_my_topics
        end
      end
      resources :followups do
      end
      resources :comments do
      end
    end

##############################################################################
    get 'teachers/forget_password' => 'teachers#forget_password'

############################################################################
    resources :schools do
      collection do
        get :all
        get :school
      end

      resources :ecirculars, only: [:create], shallow: true do
        collection do
          get :all
          post :upload_file
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
        resources :subjects, only: [:create, :update, :destroy], shallow: true do

        end
        resources :divisions, only: [:index, :create, :update, :destroy], shallow: true do

        end
      end
    end

    resource :parents do
      get "/dashboards/parents_dashboard" => 'parents/dashboards#parents_dashboard'
    end

    resources :activities, only: [:create] do
      member do
        put :deactivate
      end
      collection do
        get :all
        post :upload_file
      end
    end

    resource :user, only: [] do
      collection do
        patch 'update_password'
      end
    end

  resource :teacher, only: [] do
    collection do
      patch 'update_password'
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
      get  "/teacher/forgot_password" => "teachers#forgot_password"
      get  "/teacher/parents" => "teachers#index"
      get  "/teacher/ecirculars/:id/read" => 'teachers#circular_read'

      get  "/ecirculars/circular_teachers" => "ecirculars#circular_teachers"
      post "/ecircular/tags" => "ecirculars#tags"
      post "/ecircular/create" => "ecirculars#create"
      get  "/ecirculars" => "ecirculars#index"
      post "/ecirculars" => "ecirculars#index"
      get  "/ecirculars/:id" => "ecirculars#circular"
      get  "/ecirculars/circular_teachers" => "ecirculars#circular_teachers"

      get  "/activities" => "activities#index"
      get  "/activities/activity/:id" => "activities#activity"
      get  "/activity/categories" => "activities#get_categories"
      post "/activity/:activity_id/share" => "activities#share"


      post "/parent/login" => 'parents#login'
      post "/parent/reset_password" => 'parents#reset_password'
      get  "/parent/profile" => 'parents#profile'
      post "/parent/ecirculars" => 'parents#circulars'
      post "/parent/ecirculars/:id" => 'parents#circular'
      post "/parent/activities" => 'parents#activities'
      post "/parent/activities/:id" => 'parents#activity'
      get  "/parent/forgot_password" => "parents#forgot_password"
      get  "/parent/ecirculars/:id/read" => 'parents#circular_read'

      get  "/teacher/topics" => 'teachers#topics'
      post "/teacher/topics" => 'teachers#create_topic'

      post "device/register" => 'devices#register'
      post "device/deregister" => 'devices#de_register'

      post "/bookmarks/create" => 'bookmarks#create'
      get  "/bookmarks" => 'bookmarks#index'
      post "/bookmarks/add_caption" => 'bookmarks#add_caption'

      post "/collaborate" => 'collaborations#collaborate'
      get  "/collaboration" => 'collaborations#index'

      get "/collaboration/:bookmark_id/like" => "collaborations#like"
      get "/collaboration/:bookmark_id/unlike" => "collaborations#unlike"
      get  "/collaboration/:bookmark_id/view" => "collaborations#view"
      get "/collaboration/:collaboration_id/comments" => 'collaborations#get_comment'
      post "/collaboration/:bookmark_id/comment" => 'collaborations#comment'
      get  "/collaboration/:bookmark_id/add_to_my_bookmarks" => 'collaborations#add_to_my_bookmarks'


      post "/followup" => 'followups#followup'
      get  "parent/followups" => 'followups#index'
      get  "teacher/followups" => 'followups#index'
      get  "parent/followups/:student_id" => 'followups#index'

      get "/followups/:bookmark_id/like" => "followups#like"
      get "/followups/:bookmark_id/unlike" => "followups#unlike"
      get  "/followups/:bookmark_id/view" => "followups#view"
      post "/followups/:bookmark_id/comment" => 'followups#comment'

      get  "/followups/activities" => "activities#shared_activities"

    end
  end

  get  "/admin/notifications" => 'admin/notifications#show', as: :admin_show_nofifcation
  post "/admin/notifications" => 'admin/notifications#send_notification'

end
