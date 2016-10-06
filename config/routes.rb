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
                         sessions: 'teachers/sessions',
                         registrations: 'teachers/registrations',
                         passwords: 'teachers/passwords',
                         invitations: 'teachers/invitations'
  }


  devise_for :parents, controllers:{
                         sessions: 'parents/sessions',
                         registrations: 'parents/registrations',
                         passwords: 'parents/passwords',
                         invitations: 'parents/invitations'
  }

  namespace :admin do
    resource :users do
      get "/dashboards/index" => 'users/dashboards#index'
      get "/dashboards/admin_dashboard" => 'users/dashboards#admin_dashboard'
      get "/dashboards/school_admin_dashboard" => 'users/dashboards#school_admin_dashboard'
    end
  end

  resource :parents do
    get "/dashboards/parents_dashboard" => 'parents/dashboards#parents_dashboard'
  end

  namespace :api do
    namespace :v1 do
    end
  end
end
