require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      @user = User.create(:username => params[:username], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/login'
    end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by(:username => params[:username])
    # # if params[:username] == "" || params[:password] == ""
    # #   redirect '/failure'
    # # else
    # #    if user && user.authenticate(params[:password])
    # #     redirect '/account'
    # #   end
    # # end
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/account' #redirect versus redirect to??
    else
      redirect '/failure'
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
