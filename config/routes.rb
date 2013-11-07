VampsApp7::Application.routes.draw do

  # get "home/index"
  
  devise_for :users
  devise_scope :user do
      get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :projects

  root :to => "pages#home"
  get  'pages/overview', as: :overview
  get  'pages/faq',      as: :faq
  get  'pages/contact',  as: :contact

  resources :visualization

  post 'visualization/tax_table',  as: :tax_table
  #get 'visualization/heatmap',    as: :heatmap
  post 'visualization/heatmap',    as: :heatmap
  post 'visualization/bar_charts', as: :bar_charts
  post 'visualization/parse_view'
  #get 'visualization/generate_data_download'
  #match /visualization/generate_data_download/:id => "visualization#generate_data_download"
  
  post '/visualization/what_to_show/:view', :controller => 'visualization', :action => 'what_to_show'
  
  get "downloads/generate_data_download"
  
  resources :sequence
  resources :project_dataset
  
  

  #get 'projects/:xml' => 'projects#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
