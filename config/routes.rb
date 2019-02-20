Guillotine::Application.routes.draw do
  resources :comments

  devise_for :users
  resources :users, only: [:index, :new, :create, :destroy]

  resources :semesters, only: [:index,:update,:create,:destroy] do
    resource :pledges, only: %i[show update], module: :semesters
  end

  get 'gpo', to: "gpo#index"
  get "gpo/single/:id", to: 'gpo#single'
  get "gpo/all"
  put 'gpo/mark_all_sent'
  get "gpo/creditcards"
  post "gpo/creditcards", to: 'gpo#process_creditcards'

  get "home/index"

  get "rewards/new/pledger-:pledger_id", :pledger_id => /[0-9]+/, to: 'rewards#new'
  get "rewards/packing_slips", to: 'rewards#packing_slips'
  resources :rewards


  get "donations/:year/:month", :year => /[0-9]{4}/, :month => /[0-9]{2}/, to: 'donations#index'
  get "donations/underwriting", to: 'donations#underwriting'
  post "donations/forgive", to: 'donations#forgive'
  resources :donations do
    resource :credit_card_form, only: [:show]
  end
  resources :credit_card_forms, only: [:new]

  get "pledge_forms", to: "pledge_forms#index"
  get "pledge_forms/all"
  put "pledge_forms/mark_all_sent"
  resources :pledge_forms, only: [:index]


  get "shows/:year/:month", :year => /[0-9]{4}/, :month => /[0-9]{2}/, to: 'shows#index'
  resources :shows


  resources :items


  resources :slots, except: [:show]
  get "slots/:year/:month", :year => /[0-9]{4}/, :month => /[0-9]{2}/, to: 'slots#index'


  resources :pledgers do
    collection do
      get 'search'
    end
  end

  resources :settings, only: [:update], param: :id

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
