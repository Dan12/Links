Rails.application.routes.draw do
  root "application#index"
  
  # user
  # create
  get "/user/new" => "user#new"
  post "/user/create" => "user#create"
  get "/user/login_page" => "user#login_page"
  post "/user/login" => "user#login"
  get "/user/logout" => "user#logout"
  
  # read
  get "/user/view/:id" => "user#view"
  
  # update
  get "/user/edit/:id" => "user#edit"
  post "/user/update/:id" => "user#update"
  
  # destroy
  get "/user/destroy/:id" => "user#destroy"
  
  # links
  # create
  get "/link/new" => "link#new"
  post "/link/create" => "link#create"
  
  # read
  get "/link/tags" => "link#tags"
  post "/link/tag_suggestions" => "link#tag_suggestions"
  
  # update
  get "/link/edit/:id" => "link#edit"
  get "/link/edit_index" => "link#edit_index"
  post "/link/update/:id" => "link#update"
  post "/link/add_tag/:id" => "link#add_tag"
  post "/link/remove_tag/:id" => "link#remove_tag"
  
  # destroy
  get "/link/destroy/:id" => "link#destroy"
end
