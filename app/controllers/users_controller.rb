class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:new, :create]

  def new
    @user = User.new
    @title = "Add User"
  end
  
  def create
    @user = User.new
    @user.accessible = [:admin] if current_user.admin?
    @user.update_attributes(params[:user])
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
    @wish_item = WishItem.new
    @categories = WishCategory.all
    @title = @user.name
  end
  
  def edit
    @title = "Edit Account"
  end
  
  def update
    unless current_user.has_password?(params[:old_password]) || current_user.admin?
      flash.now[:error] = "Current password entered does not match your actual password."
      @title = "Edit Account"
      return render 'edit'
    end
    if @user.update_attributes(params[:user])
      flash[:success] = "Account updated."
      redirect_to @user
    else
      @title = "Edit Account"
      render 'edit'
    end
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
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
end
