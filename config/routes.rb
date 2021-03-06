Rails.application.routes.draw do

devise_for :users, :controllers => { :registrations => "registrations" }

resources :conversations, only: [:index, :show, :destroy] do
     member do
       post :reply
       post :restore
       post :mark_as_read
     end
     collection do
       delete :empty_trash
     end
end

 resources :users, only: [:index]

 resources :messages, only: [:new, :create]

 resources :works, only: [:show, :index] do
   resources :resumes, only: [:new, :create]
 end

 resources :applies, only: [:new, :create]

  namespace :company do
    resources :works do
      resources :resumes
    end
  end

  resources :notifications, only: [] do
    member do
      get :redirect_notification
    end
  end

  namespace :admin do
    resources :applies, only: [:index, :show, :destroy] do
      member do
        post :failed
        post :passing
        post :application
      end
    end
    resources :works do
      member do
        post :publish
        post :hide
      end
    end
    resources :users, only: [:index, :show, :destroy] do
      member do
        post :admin
        post :user
      end
    end
  end

  root "works#index"

end
