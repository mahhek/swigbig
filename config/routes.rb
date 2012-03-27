Swigbig::Application.routes.draw do

  resources :contacts

  get "favourite_bar", :to => "bar#favourite_bar", :as => :favourite_bar

  get "/dashboard/invite", :to => "dashboard#invite", :as => :invite_user
  post "/dashboard/invite_email", :to => "dashboard#invite_email", :as => :invite_email
  get "/dashboard/twitter", :to => "dashboard#twitter", :as => :dashboard_twitter
  get "/dashboard/facebook", :to => "dashboard#facebook", :as => :dashboard_facebook
  get "/dashboard", :to => "dashboard#index", :as => :user_root
  get "/admins", :to => "admins/dashboard#index", :as => :admin_root
  get "/bars", :to => "bars/dashboard#index", :as => :bar_root
  get "/home/bars", :to => "home#bars", :as => :home_bars
  get "/faq", :to => "home#faq", :as => :faq
  get "/contact", :to => "home#contact", :as => :contact
  get "/bars/profile", :to => "bars/bars#show", :as => :bar_profile
 
  match '/find_deals' => 'api/bars/deals#find_deals', :via => :get
  devise_for :users, :controllers => { :omniauth_callbacks => "devise/omniauth_callbacks" }
  devise_for :bars #, :controllers => { :sessions => "bars/sessions" }
  devise_for :admins #, :controllers => { :sessions => "admins/sessions" }

  resource  :account, :only => [:show], :controller => :account
  
  resources :users, :only => [:show], :controller => :users
  resources :messages

  resources :activity_stream_preferences
  resources :activity_streams
  resources :status

  resources :friends do
    member do
      post 'approve'
      post 'block'
    end
  end

  namespace :admins do
    resources :dashboard, :only => [:index]
    resources :deals
    resources :users
    resources :bars
    resources :plans
    resources :logos
    resources :slogans
    resources :coupons
    resources :payment_gateways
    resources :rewards
    resources :reward_classes
  end

  namespace :bars do
    get "/settings", :to => "settings#index", :as => :settings
    get "/settings/generate_qrcode", :to => "settings#generate_qrcode", :as => :generate_qrcode
    get "/settings/generate_qrcode_poster_1", :to => "settings#generate_qrcode_poster_1", :as => :generate_qrcode_poster_1
    get "/settings/generate_qrcode_poster_2", :to => "settings#generate_qrcode_poster_2", :as => :generate_qrcode_poster_2
    get "/settings/generate_qrcode_poster_3", :to => "settings#generate_qrcode_poster_3", :as => :generate_qrcode_poster_3
    resources :dashboard, :only => [:index]
    resource :credit_cards, :only => [:show, :edit, :update]
    resources :deals do
      member do
        post "create_from_default_deal"
        put "update_from_default_deal/:deal_id", :action => :update_from_default_deal, :as => :update_from_default_deal
      end
      collection do
        get 'deal_status'
        get 'deal_status_update'
      end
    end
    resources :rewards do
      member do
        post "create_from_default_reward"
        put "update_from_default_reward/:reward_id", :action => :update_from_default_reward, :as => :update_from_default_reward
      end
      collection do
        get 'reward_status'
        get 'reward_status_update'
      end
    end

    resources :statistical_information, :only => :index
  end
  match 'dashboard/get_more_friends' => 'dashboard#get_more_friends', :via => :get, :as => "get_more_friends"
  root :to => 'home#index'
  
  match '/api/users/:id/profile' => 'api/bars#profile_user', :via => :get
  match '/api/register_account' => 'api/bars#register_account', :via => :post
  match '/api/complete_profile' => 'api/bars#complete_register', :via => :post
  match '/api/search_bars' => 'api/bars#search_bars', :via => :post
  match '/api/checkin'  => 'api/bars#checkin', :via => :post
  match '/api/invite_user' => "api/bars#invite_user", :via => :post
  match '/api/bar_directory' => "api/bars#bar_directory", :via => :get
  match '/invite_friends' => 'dashboard#invite_friends', :via => :post, :as => 'invite_friends'
  match '/deal_status' => 'api/bars/deals#deal_status', :via => :get, :as => 'deal_status'
  match '/deal_status_update' => 'api/bars/deals#deal_status_update', :via => :get, :as => 'deal_status_update'

  match '/reward_status' => 'api/bars/rewards#reward_status', :via => :get , :as => 'reward_status'
  match '/reward_status_update' => 'api/bars/rewards#reward_status_update', :via => :get, :as => 'reward_status_update'
  
  resources :swigs, :only => :show do
    collection do
      get "top_ten_swigs"
      get "top_ten_swigers"
    end
  end

  resources :user_rewards, :only => :show do
    collection do
      get "rewards"
    end
    post "shared_rewards/share/:total_unclaimed", :controller => :shared_rewards, :action => :share, :as => :share_reward
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
#== Route Map
# Generated on 28 Sep 2011 20:54
#
#                      admin_root GET    /admins(.:format)                               {:controller=>"admins/dashboard", :action=>"index"}
#                        bar_root GET    /bars(.:format)                                 {:controller=>"bars/dashboard", :action=>"index"}
#                       home_bars GET    /home/bars(.:format)                            {:controller=>"home", :action=>"bars"}
#                             faq GET    /faq(.:format)                                  {:controller=>"home", :action=>"faq"}
#                         contact GET    /contact(.:format)                              {:controller=>"home", :action=>"contact"}
#                     bar_profile GET    /bars/profile(.:format)                         {:controller=>"bars/bars", :action=>"show"}
#                new_user_session GET    /users/sign_in(.:format)                        {:action=>"new", :controller=>"devise/sessions"}
#                    user_session POST   /users/sign_in(.:format)                        {:action=>"create", :controller=>"devise/sessions"}
#            destroy_user_session DELETE /users/sign_out(.:format)                       {:action=>"destroy", :controller=>"devise/sessions"}
#          user_omniauth_callback        /users/auth/:action/callback(.:format)          {:action=>/facebook|twitter/, :controller=>"devise/omniauth_callbacks"}
#                   user_password POST   /users/password(.:format)                       {:action=>"create", :controller=>"devise/passwords"}
#               new_user_password GET    /users/password/new(.:format)                   {:action=>"new", :controller=>"devise/passwords"}
#              edit_user_password GET    /users/password/edit(.:format)                  {:action=>"edit", :controller=>"devise/passwords"}
#                                 PUT    /users/password(.:format)                       {:action=>"update", :controller=>"devise/passwords"}
#        cancel_user_registration GET    /users/cancel(.:format)                         {:action=>"cancel", :controller=>"devise/registrations"}
#               user_registration POST   /users(.:format)                                {:action=>"create", :controller=>"devise/registrations"}
#           new_user_registration GET    /users/sign_up(.:format)                        {:action=>"new", :controller=>"devise/registrations"}
#          edit_user_registration GET    /users/edit(.:format)                           {:action=>"edit", :controller=>"devise/registrations"}
#                                 PUT    /users(.:format)                                {:action=>"update", :controller=>"devise/registrations"}
#                                 DELETE /users(.:format)                                {:action=>"destroy", :controller=>"devise/registrations"}
#               user_confirmation POST   /users/confirmation(.:format)                   {:action=>"create", :controller=>"devise/confirmations"}
#           new_user_confirmation GET    /users/confirmation/new(.:format)               {:action=>"new", :controller=>"devise/confirmations"}
#                                 GET    /users/confirmation(.:format)                   {:action=>"show", :controller=>"devise/confirmations"}
#          accept_user_invitation GET    /users/invitation/accept(.:format)              {:action=>"edit", :controller=>"devise/invitations"}
#                 user_invitation POST   /users/invitation(.:format)                     {:action=>"create", :controller=>"devise/invitations"}
#             new_user_invitation GET    /users/invitation/new(.:format)                 {:action=>"new", :controller=>"devise/invitations"}
#                                 PUT    /users/invitation(.:format)                     {:action=>"update", :controller=>"devise/invitations"}
#                 new_bar_session GET    /bars/sign_in(.:format)                         {:action=>"new", :controller=>"bars/sessions"}
#                     bar_session POST   /bars/sign_in(.:format)                         {:action=>"create", :controller=>"bars/sessions"}
#             destroy_bar_session DELETE /bars/sign_out(.:format)                        {:action=>"destroy", :controller=>"bars/sessions"}
#                    bar_password POST   /bars/password(.:format)                        {:action=>"create", :controller=>"devise/passwords"}
#                new_bar_password GET    /bars/password/new(.:format)                    {:action=>"new", :controller=>"devise/passwords"}
#               edit_bar_password GET    /bars/password/edit(.:format)                   {:action=>"edit", :controller=>"devise/passwords"}
#                                 PUT    /bars/password(.:format)                        {:action=>"update", :controller=>"devise/passwords"}
#         cancel_bar_registration GET    /bars/cancel(.:format)                          {:action=>"cancel", :controller=>"devise/registrations"}
#                bar_registration POST   /bars(.:format)                                 {:action=>"create", :controller=>"devise/registrations"}
#            new_bar_registration GET    /bars/sign_up(.:format)                         {:action=>"new", :controller=>"devise/registrations"}
#           edit_bar_registration GET    /bars/edit(.:format)                            {:action=>"edit", :controller=>"devise/registrations"}
#                                 PUT    /bars(.:format)                                 {:action=>"update", :controller=>"devise/registrations"}
#                                 DELETE /bars(.:format)                                 {:action=>"destroy", :controller=>"devise/registrations"}
#                bar_confirmation POST   /bars/confirmation(.:format)                    {:action=>"create", :controller=>"devise/confirmations"}
#            new_bar_confirmation GET    /bars/confirmation/new(.:format)                {:action=>"new", :controller=>"devise/confirmations"}
#                                 GET    /bars/confirmation(.:format)                    {:action=>"show", :controller=>"devise/confirmations"}
#               new_admin_session GET    /admins/sign_in(.:format)                       {:action=>"new", :controller=>"admins/sessions"}
#                   admin_session POST   /admins/sign_in(.:format)                       {:action=>"create", :controller=>"admins/sessions"}
#           destroy_admin_session DELETE /admins/sign_out(.:format)                      {:action=>"destroy", :controller=>"admins/sessions"}
#                    admin_unlock POST   /admins/unlock(.:format)                        {:action=>"create", :controller=>"devise/unlocks"}
#                new_admin_unlock GET    /admins/unlock/new(.:format)                    {:action=>"new", :controller=>"devise/unlocks"}
#                                 GET    /admins/unlock(.:format)                        {:action=>"show", :controller=>"devise/unlocks"}
#                         account GET    /account(.:format)                              {:action=>"show", :controller=>"account"}
#                            user GET    /users/:id(.:format)                            {:action=>"show", :controller=>"users"}
#                        messages GET    /messages(.:format)                             {:action=>"index", :controller=>"messages"}
#                                 POST   /messages(.:format)                             {:action=>"create", :controller=>"messages"}
#                     new_message GET    /messages/new(.:format)                         {:action=>"new", :controller=>"messages"}
#                    edit_message GET    /messages/:id/edit(.:format)                    {:action=>"edit", :controller=>"messages"}
#                         message GET    /messages/:id(.:format)                         {:action=>"show", :controller=>"messages"}
#                                 PUT    /messages/:id(.:format)                         {:action=>"update", :controller=>"messages"}
#                                 DELETE /messages/:id(.:format)                         {:action=>"destroy", :controller=>"messages"}
#     activity_stream_preferences GET    /activity_stream_preferences(.:format)          {:action=>"index", :controller=>"activity_stream_preferences"}
#                                 POST   /activity_stream_preferences(.:format)          {:action=>"create", :controller=>"activity_stream_preferences"}
#  new_activity_stream_preference GET    /activity_stream_preferences/new(.:format)      {:action=>"new", :controller=>"activity_stream_preferences"}
# edit_activity_stream_preference GET    /activity_stream_preferences/:id/edit(.:format) {:action=>"edit", :controller=>"activity_stream_preferences"}
#      activity_stream_preference GET    /activity_stream_preferences/:id(.:format)      {:action=>"show", :controller=>"activity_stream_preferences"}
#                                 PUT    /activity_stream_preferences/:id(.:format)      {:action=>"update", :controller=>"activity_stream_preferences"}
#                                 DELETE /activity_stream_preferences/:id(.:format)      {:action=>"destroy", :controller=>"activity_stream_preferences"}
#                activity_streams GET    /activity_streams(.:format)                     {:action=>"index", :controller=>"activity_streams"}
#                                 POST   /activity_streams(.:format)                     {:action=>"create", :controller=>"activity_streams"}
#             new_activity_stream GET    /activity_streams/new(.:format)                 {:action=>"new", :controller=>"activity_streams"}
#            edit_activity_stream GET    /activity_streams/:id/edit(.:format)            {:action=>"edit", :controller=>"activity_streams"}
#                 activity_stream GET    /activity_streams/:id(.:format)                 {:action=>"show", :controller=>"activity_streams"}
#                                 PUT    /activity_streams/:id(.:format)                 {:action=>"update", :controller=>"activity_streams"}
#                                 DELETE /activity_streams/:id(.:format)                 {:action=>"destroy", :controller=>"activity_streams"}
#                    status_index GET    /status(.:format)                               {:action=>"index", :controller=>"status"}
#                                 POST   /status(.:format)                               {:action=>"create", :controller=>"status"}
#                      new_status GET    /status/new(.:format)                           {:action=>"new", :controller=>"status"}
#                     edit_status GET    /status/:id/edit(.:format)                      {:action=>"edit", :controller=>"status"}
#                          status GET    /status/:id(.:format)                           {:action=>"show", :controller=>"status"}
#                                 PUT    /status/:id(.:format)                           {:action=>"update", :controller=>"status"}
#                                 DELETE /status/:id(.:format)                           {:action=>"destroy", :controller=>"status"}
#                  approve_friend POST   /friends/:id/approve(.:format)                  {:action=>"approve", :controller=>"friends"}
#                    block_friend POST   /friends/:id/block(.:format)                    {:action=>"block", :controller=>"friends"}
#                         friends GET    /friends(.:format)                              {:action=>"index", :controller=>"friends"}
#                                 POST   /friends(.:format)                              {:action=>"create", :controller=>"friends"}
#                      new_friend GET    /friends/new(.:format)                          {:action=>"new", :controller=>"friends"}
#                     edit_friend GET    /friends/:id/edit(.:format)                     {:action=>"edit", :controller=>"friends"}
#                          friend GET    /friends/:id(.:format)                          {:action=>"show", :controller=>"friends"}
#                                 PUT    /friends/:id(.:format)                          {:action=>"update", :controller=>"friends"}
#                                 DELETE /friends/:id(.:format)                          {:action=>"destroy", :controller=>"friends"}
#          admins_dashboard_index GET    /admins/dashboard(.:format)                     {:action=>"index", :controller=>"admins/dashboard"}
#                    admins_deals GET    /admins/deals(.:format)                         {:action=>"index", :controller=>"admins/deals"}
#                                 POST   /admins/deals(.:format)                         {:action=>"create", :controller=>"admins/deals"}
#                 new_admins_deal GET    /admins/deals/new(.:format)                     {:action=>"new", :controller=>"admins/deals"}
#                edit_admins_deal GET    /admins/deals/:id/edit(.:format)                {:action=>"edit", :controller=>"admins/deals"}
#                     admins_deal GET    /admins/deals/:id(.:format)                     {:action=>"show", :controller=>"admins/deals"}
#                                 PUT    /admins/deals/:id(.:format)                     {:action=>"update", :controller=>"admins/deals"}
#                                 DELETE /admins/deals/:id(.:format)                     {:action=>"destroy", :controller=>"admins/deals"}
#                    admins_users GET    /admins/users(.:format)                         {:action=>"index", :controller=>"admins/users"}
#                                 POST   /admins/users(.:format)                         {:action=>"create", :controller=>"admins/users"}
#                 new_admins_user GET    /admins/users/new(.:format)                     {:action=>"new", :controller=>"admins/users"}
#                edit_admins_user GET    /admins/users/:id/edit(.:format)                {:action=>"edit", :controller=>"admins/users"}
#                     admins_user GET    /admins/users/:id(.:format)                     {:action=>"show", :controller=>"admins/users"}
#                                 PUT    /admins/users/:id(.:format)                     {:action=>"update", :controller=>"admins/users"}
#                                 DELETE /admins/users/:id(.:format)                     {:action=>"destroy", :controller=>"admins/users"}
#                     admins_bars GET    /admins/bars(.:format)                          {:action=>"index", :controller=>"admins/bars"}
#                                 POST   /admins/bars(.:format)                          {:action=>"create", :controller=>"admins/bars"}
#                  new_admins_bar GET    /admins/bars/new(.:format)                      {:action=>"new", :controller=>"admins/bars"}
#                 edit_admins_bar GET    /admins/bars/:id/edit(.:format)                 {:action=>"edit", :controller=>"admins/bars"}
#                      admins_bar GET    /admins/bars/:id(.:format)                      {:action=>"show", :controller=>"admins/bars"}
#                                 PUT    /admins/bars/:id(.:format)                      {:action=>"update", :controller=>"admins/bars"}
#                                 DELETE /admins/bars/:id(.:format)                      {:action=>"destroy", :controller=>"admins/bars"}
#                    admins_plans GET    /admins/plans(.:format)                         {:action=>"index", :controller=>"admins/plans"}
#                                 POST   /admins/plans(.:format)                         {:action=>"create", :controller=>"admins/plans"}
#                 new_admins_plan GET    /admins/plans/new(.:format)                     {:action=>"new", :controller=>"admins/plans"}
#                edit_admins_plan GET    /admins/plans/:id/edit(.:format)                {:action=>"edit", :controller=>"admins/plans"}
#                     admins_plan GET    /admins/plans/:id(.:format)                     {:action=>"show", :controller=>"admins/plans"}
#                                 PUT    /admins/plans/:id(.:format)                     {:action=>"update", :controller=>"admins/plans"}
#                                 DELETE /admins/plans/:id(.:format)                     {:action=>"destroy", :controller=>"admins/plans"}
#                    admins_logos GET    /admins/logos(.:format)                         {:action=>"index", :controller=>"admins/logos"}
#                                 POST   /admins/logos(.:format)                         {:action=>"create", :controller=>"admins/logos"}
#                 new_admins_logo GET    /admins/logos/new(.:format)                     {:action=>"new", :controller=>"admins/logos"}
#                edit_admins_logo GET    /admins/logos/:id/edit(.:format)                {:action=>"edit", :controller=>"admins/logos"}
#                     admins_logo GET    /admins/logos/:id(.:format)                     {:action=>"show", :controller=>"admins/logos"}
#                                 PUT    /admins/logos/:id(.:format)                     {:action=>"update", :controller=>"admins/logos"}
#                                 DELETE /admins/logos/:id(.:format)                     {:action=>"destroy", :controller=>"admins/logos"}
#                  admins_slogans GET    /admins/slogans(.:format)                       {:action=>"index", :controller=>"admins/slogans"}
#                                 POST   /admins/slogans(.:format)                       {:action=>"create", :controller=>"admins/slogans"}
#               new_admins_slogan GET    /admins/slogans/new(.:format)                   {:action=>"new", :controller=>"admins/slogans"}
#              edit_admins_slogan GET    /admins/slogans/:id/edit(.:format)              {:action=>"edit", :controller=>"admins/slogans"}
#                   admins_slogan GET    /admins/slogans/:id(.:format)                   {:action=>"show", :controller=>"admins/slogans"}
#                                 PUT    /admins/slogans/:id(.:format)                   {:action=>"update", :controller=>"admins/slogans"}
#                                 DELETE /admins/slogans/:id(.:format)                   {:action=>"destroy", :controller=>"admins/slogans"}
#                  admins_coupons GET    /admins/coupons(.:format)                       {:action=>"index", :controller=>"admins/coupons"}
#                                 POST   /admins/coupons(.:format)                       {:action=>"create", :controller=>"admins/coupons"}
#               new_admins_coupon GET    /admins/coupons/new(.:format)                   {:action=>"new", :controller=>"admins/coupons"}
#              edit_admins_coupon GET    /admins/coupons/:id/edit(.:format)              {:action=>"edit", :controller=>"admins/coupons"}
#                   admins_coupon GET    /admins/coupons/:id(.:format)                   {:action=>"show", :controller=>"admins/coupons"}
#                                 PUT    /admins/coupons/:id(.:format)                   {:action=>"update", :controller=>"admins/coupons"}
#                                 DELETE /admins/coupons/:id(.:format)                   {:action=>"destroy", :controller=>"admins/coupons"}
#                   bars_settings GET    /bars/settings(.:format)                        {:controller=>"bars/settings", :action=>"index"}
#            bars_generate_qrcode GET    /bars/settings/generate_qrcode(.:format)        {:controller=>"bars/settings", :action=>"generate_qrcode"}
#            bars_dashboard_index GET    /bars/dashboard(.:format)                       {:action=>"index", :controller=>"bars/dashboard"}
#          edit_bars_credit_cards GET    /bars/credit_cards/edit(.:format)               {:action=>"edit", :controller=>"bars/credit_cards"}
#               bars_credit_cards GET    /bars/credit_cards(.:format)                    {:action=>"show", :controller=>"bars/credit_cards"}
#                                 PUT    /bars/credit_cards(.:format)                    {:action=>"update", :controller=>"bars/credit_cards"}
#                            root        /                                               {:controller=>"home", :action=>"index"}
