class WishItemsController < ApplicationController

  def create
  end

  def destroy
  end
  
  def index
    @users = User.all
  end
  
end