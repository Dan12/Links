class UserController < ApplicationController
    
    skip_before_filter :authorize, :only => [:new, :create]
    
    # sign up page
    def new
       render "signup" 
    end
    
    # sign up action
    def create
        u = User.new
        u.name=params[:username]
        u.email=params[:email]
        u.password=params[:password]
        u.password_confirmation=params[:confirm_password]
        if u.save
           session[:user_id] = u.id
           redirect_to("/user/view/#{u.id}")
        else
            @error_message = "There was an error"
            render "signup"
        end
    end
    
    # login page
    def login_page
        render "login"
    end
    
    # login action
    def login
        u = User.find_by(name: params[:username])
        if u.authenticate(params[:password])
           session[:user_id] = u.id
           redirect_to "/user/view/#{u.id}"
        else
            @error_message = "Incorrect username or password"
            render "login"
        end
    end
    
    # logout action
    def logout
        session[:user_id] = nil
        redirect_to "/"
    end
    
    # view page
    def view
        @user = User.find_by(id: params[:id])
        render "view"
    end
    
    # edit page
    def edit
        @user = User.find_by(id: params[:id])
        render "edit"
    end
    
    # edit action
    def update
        u = User.find_by(id: params[:id])
        u.name=params[:username]
        u.email=params[:email]
        u.password=params[:password]
        u.password_confirmation=params[:confirm_password]
        if u.save
            redirect_to("/user/view/#{u.id}")
        else
            @error_message = "There was an error"
            @user = u
            render "edit"
        end
    end
    
    # destroy action
    def destroy
        
    end
end