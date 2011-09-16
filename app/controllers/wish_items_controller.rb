class WishItemsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def create
    @wish_item = current_user.wish_items.build(params[:wish_item])
    @wish_item.description.gsub!(/\n/, "<br/>")
    if WishCategory.count == 0
      WishCategory.create(:name => "none")
    end
    category = WishCategory.first
    @wish_item.category_id = category.id
    if @wish_item.save
      flash[:success] = "Added wish"
      redirect_back_or root_path
    else
      get_users
      render 'wish_items/bare_wish_item_form'
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
    end
    store_location
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