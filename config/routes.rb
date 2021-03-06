Rails.application.routes.draw do

  # Static pages.
  root 'pages#home'
  get '/charter', to: 'pages#charter'
  get '/logs', to: 'pages#logs'

  # Devise user authentication.
  devise_for :users, skip: :registration

  # Contents.
  resources :contents, only: [:create, :update]

  # Shouts
  resources :shouts, only: [:index, :create, :destroy]

  # Users, characters and applications.
  get '/roster', to: 'characters#roster'
  resources :users do
    member { patch 'toggle' }
    resources :characters, only: [:new, :create, :destroy] do
      patch :promote
    end
    resources :uploads, except: [:show, :edit, :update]
    resource :application do
      member { match 'decide', via: [:put, :patch] }
      member { patch 'toggle' }
    end
  end
  get '/applications', to: 'applications#index'

  # Recruitment.
  resource :recruitment, only: [:show, :edit, :update]

  # Raids and bosses.
  resources :raids do
    member { patch 'toggle' }
    resources :bosses, except: :index do
      member { patch 'toggle' }
    end
  end

  # Forums and topics.
  resources :forums do
    resources :topics, except: [:index, :new]
  end

  # Posts, my implementation requires only 1 layer of nesting.
  scope 'raids/:raid_id', as: :raid do
    resources :posts, only: [:create, :update, :destroy]
  end
  scope 'bosses/:boss_id', as: :boss do
    resources :posts, only: [:create, :update, :destroy]
  end
  scope 'topics/:topic_id', as: :topic do
    resources :posts, only: [:create, :update, :destroy]
  end
  scope 'applications/:application_id', as: :application do
    resources :posts, only: [:create, :update, :destroy]
  end

end
