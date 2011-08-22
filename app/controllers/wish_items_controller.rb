class WishItemsController < ApplicationController

  def create
  end

  def destroy
  end
  
  def index
    @wish_items = WishItem.all
  end
  
end