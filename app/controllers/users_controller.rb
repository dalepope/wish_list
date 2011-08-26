class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Add User"
  end

end
