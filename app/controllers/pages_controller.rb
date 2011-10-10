class PagesController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user, :except => :draw_rules

  def admin
    @title = "Administration"
  end
  
  def draw_rules
    @givers = User.find_all_by_in_draw(true)
    @drawless = User.find_all_by_in_draw(false)
    @title = "Draw Rules"
  end
  
  def ownerships
    @users = User.all
    @title = "User Ownerships"
  end
end
