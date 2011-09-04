class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :index]
  before_filter :admin_user, :only => [:new, :create]

  def new
    @user = User.new
    @title = "Add User"
  end
  
  def create
    @user = User.new
    @user.accessible = [:admin] if current_user.admin?
    @user.update_attributes(params[:user])
    # @user = User.new(params[:user])
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

  def show
    @user = User.find(params[:id])
    @wish_items = @user.wish_items
    @title = @user.name
  end
  
  def index
    @users = User.all
    @title = "Wishers"
  end
  
  private
  
    def admin_user
      unless current_user.admin?
        flash[:error] = "You do not have permission to #{request.fullpath}."
        redirect_to(root_path)
      end
    end
end
