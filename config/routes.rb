Rails.application.routes.draw do
  root "home#index"
  get "about", to: "pages#about"
  get "now", to: "pages#now"
  get "colophon", to: "pages#colophon"
  get "writings", to: "posts#index"
  get "archive", to: "posts#archive"
  get "writings/:slug", to: "posts#show", as: :writing
  get "rss.xml", to: "posts#feed", defaults: { format: :xml }, as: :rss
  get "sitemap.xml", to: "sitemap#index", defaults: { format: :xml }, as: :sitemap
  get "projects", to: "pages#projects"
  get "projects/:slug", to: "pages#project", as: :project
  get "links", to: "pages#links"
  get "uses", to: "pages#uses"
  get "privacy", to: "pages#privacy"
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  get "guestbook", to: "guestbook_entries#index", as: :guestbook
  get "subscribe", to: "pages#subscribe"
  post "guestbook", to: "guestbook_entries#create"
  post "subscribe", to: "subscribers#create"
  get "subscribe/confirm/:token", to: "subscribers#confirm", as: :confirm_subscription
  get "subscribe/unsubscribe/:token", to: "subscribers#unsubscribe", as: :unsubscribe_subscription

  namespace :admin do
    root "posts#index"
    get "analytics", to: "analytics#show", as: :analytics
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"
    resources :posts do
      member do
        patch :publish
        patch :unpublish
      end
    end
    resources :newsletters do
      member { post :send_newsletter }
    end
    resources :subscribers, only: :index do
      member { post :resend_confirmation }
    end
    resources :guestbook_entries, only: %i[index destroy] do
      member { patch :approve }
    end
    resources :site_pages, only: %i[index edit update]
    resources :projects
    resources :links
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
