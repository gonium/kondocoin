KondoCoin::Application.routes.draw do
  # For testing: Pin the locale to :en
  if Rails.env.test?
    defaults = {:locale => 'en'}
  else
    defaults = {}
  end
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/, :defaults => defaults do
    match '/',        to: 'static_pages#home',   via: 'get'
    match '/home',    to: 'static_pages#home',   via: 'get'
    match '/about',   to: 'static_pages#about',   via: 'get'
    match '/where',   to: 'static_pages#where',   via: 'get'
    match '/imprint', to: 'static_pages#imprint', via: 'get'
    match '/redeem',  to: 'voucher#index',   via: 'get'
    match '/redeem',  to: 'voucher#redeem',   via: 'post'
    match '/payout',  to: 'voucher#payout',   via: 'post'
    match '/success', to: 'voucher#success',   via: 'get'
  end
  match '*path', to: redirect("/#{I18n.default_locale}/%{path}"), 
    constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" },
    via: '[:get, :post]'
  root to: redirect("/#{I18n.default_locale}/")#, via: '[:get]'

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
