class WishItemsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    params[:wish_item][:url] = "http://" + params[:wish_item][:url] unless params[:wish_item][:url].downcase.starts_with?("http") or params[:wish_item][:url].blank?
    @wish_item = current_user.wish_items.build(params[:wish_item])
    @wish_item.description.gsub!(/\n/, "<br/>")
    if WishCategory.count == 0
      WishCategory.create(:name => "none")
    end
    category = WishCategory.first
    @wish_item.category_id = category.id
    if @wish_item.save
      flash[:success] = "Added wish"
      respond_to do |format|
        format.html { redirect_back_or root_path @user }
        format.js
      end
    else
      get_users
      respond_to do |format|
        format.html { render 'wish_items/bare_wish_item_form' }
        format.js
      end
    end
  end

  def destroy
    @wish_item.destroy
    redirect_back_or root_path
  end
  
  def index
    get_users
    if logged_in?
      @wish_item = WishItem.new
      store_location
    end
  end

  private
  
    def get_users
      @users = User.all
      if logged_in?
        current_user_index = @users.index { |i| i.id == current_user.id }
        @users.unshift(@users.slice!(current_user_index))
      end
    end
    
    def authorized_user
      @wish_item = current_user.wish_items.find_by_id(params[:id])
      redirect_to root_path if @wish_item.nil?
    end

end