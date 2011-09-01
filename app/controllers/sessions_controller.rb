class SessionsController < ApplicationController

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
      redirect_to user
    end
  end
  
  def destroy
    log_out
    redirect_to root_path
  end
end
