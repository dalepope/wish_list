class SessionsController < ApplicationController
  before_filter :authenticate, :only => [:switch]

  def new
    @title = "Log In"
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Log In"
      render 'new'
    else
      log_in user
      redirect_back_or user
    end
  end
  
  def destroy
    log_out
    redirect_to root_path
  end
  
  def switch
    new_user = User.find_by_id(params[:session][:id])
    if current_user.owns?(new_user)
      log_out
      log_in new_user
      redirect_to new_user
    else
      flash.now[:error] = "You do not have access to that account."
      redirect_to current_user
    end
  end
end
