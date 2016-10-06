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
      get "/dashboards/index" => 'users/dashboards#index'
      get "/dashboards/admin_dashboard" => 'users/dashboards#admin_dashboard'
      get "/dashboards/school_admin_dashboard" => 'users/dashboards#school_admin_dashboard'
    end
    
    resource :schools do
      get "new" => 'schools#new'
      post "new" => 'schools#create'
    end
  end

  namespace :api do
    namespace :v1 do
    end
  end
end
