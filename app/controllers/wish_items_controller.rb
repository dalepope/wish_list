class WishItemsController < ApplicationController

  def create
    @wish = current_user.wish_items.build(params[:wish_item])
    category = WishCategory.first
    @wish.category_id = category.id
    if @wish.save
      flash[:success] = "Added wish"
      redirect_to root_path
    else
      render root_path
    end
  end

  def destroy
  end
  
  def index
    @users = User.all
    if logged_in?
      @wish_item = WishItem.new
      @categories = WishCategory.all
      if @categories.count == 0
        WishCategory.create(:name => "none")
      end
    end
  end
  
end