class WishItemsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]

  def create
    @wish_item = current_user.wish_items.build(params[:wish_item])
    category = WishCategory.first
    @wish_item.category_id = category.id
    if @wish_item.save
      flash[:success] = "Added wish"
      redirect_to root_path
    else
      get_users
      render 'wish_items/index'
    end
  end

  def destroy
  end
  
  def index
    get_users
    if logged_in?
      @wish_item = WishItem.new
      if WishCategory.all.count == 0
        WishCategory.create(:name => "none")
      end
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
end