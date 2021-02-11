Rails.application.routes.draw do
  get "tasks/new" => "tasks#new"
  get "tasks/weekly" => "tasks#weekly"
  get "tasks/unfinished" => "tasks#unfinished"
  post "tasks/create" => "tasks#create"
  get "tasks/:id" => "tasks#show"
  get "tasks/:id/edit" => "tasks#edit"
  post "tasks/:id/update" => "tasks#update"
  post "tasks/:id/destroy" => "tasks#destroy"
  post "tasks/:id/add" => "tasks#add"
  post "tasks/:id/delete" => "tasks#delete"
  post "tasks/:id/nextday" => "tasks#nextday"

  get "events/new" => "events#new"
  post "events/create" => "events#create"
  get "events/:id" => "events#show"
  get "events/:id/edit" => "events#edit"
  post "events/:id/destroy" => "events#destroy"
  post "events/:id/update" => "events#update"

  post "callback" => "linebot#callback"

  get "auth" => "line_login#auth_top"
  post "line_signup" => "line_login#line_signup"

  post "logout" => "users#logout"

  get "home/index" => "home#index"
  get "home/memory" => "home#memory"
  get "signup_branch" => "home#signup_branch"
  get "normal_signup" => "home#get_normal_signup"
  get "normal_login" => "home#normal_login"
  post "normal_login_check" => "home#normal_login_check"
  post "normal_signup" => "home#post_normal_signup"
  get "/" => "home#top"

end
