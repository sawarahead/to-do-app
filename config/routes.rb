Rails.application.routes.draw do
  get 'tasks/new'
  get 'tasks/memory'
  get 'tasks/weekly'
  get 'tasks/unfinished'
  post 'tasks/create'
  get 'tasks/:id' => "tasks#show"
  get 'tasks/:id/edit' => "tasks#edit"
  post 'tasks/:id/update' => "tasks#update"
  post 'tasks/:id/destroy' => "tasks#destroy"
  post 'tasks/:id/delete' => "tasks#delete"
  post 'tasks/:id/add' => "tasks#add"

  get 'events/new'
  post'events/create'
  get 'events/:id' => "events#show"
  get 'events/:id/edit' => "events#edit"
  post 'events/:id/destroy' => "events#destroy"
  post 'events/:id/update' => "events#update"

  post 'callback' => "linebot#callback"
  get 'auth' => "line_login#auth_top"
  get 'signup' => "home#signup"
  get 'normal' => "home#normal"
  get 'home/login'
  post 'home/login_check' 
  post 'normal_signup' => "home#normal_signup"
  post 'line_signup' => "line_login#line_signup"
  post 'logout' => "users#logout"

  get 'home/index'
  get '/' => 'home#top'

end
