class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :authorize, :except => [:index, :login_page, :login]
  
  def authorize
    if session[:user_id] == nil
      redirect_to "/"
    end
  end
  
  def index
    render "index"
  end
end
