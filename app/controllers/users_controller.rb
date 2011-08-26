class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Add User"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Added user #{@user.name}"
      redirect_to users_path
    else
      @title = "Add User"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

end
