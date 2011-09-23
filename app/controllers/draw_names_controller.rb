class DrawNamesController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user

  def new
    @title = "Draw Names Status"
  end
  
  def create
    DrawnName.delete_all
  
    givers = User.find_all_by_in_draw(true)

    # todo
    givers.each do |p|
      p[:exclusions] = []
    end
 
    # draw the names (just in memory for now)
    givers.each do |g|
      available = givers.reject {|a| a[:picked] || g[:exclusions].index(a[:id]) || g[:id] == a[:id]}
      if available.count == 0
        flash.now[:error] = "Unresolvable"
        render 'new'
        return
      end
      pick = available.sample
      g[:pick] = pick
      pick[:picked] = true
    end

    # store the drawn names
    success = true
    givers.each do |g|
      g.drawn_name = DrawnName.new
      g.drawn_name.receiver = g[:pick]
      if !g.drawn_name.save
        success = false
        break
      end
    end
    
    flash.now[:success] = "Names drawn" if success
    
    render 'new'
  end
  
  private
  
    def admin_user
      unless current_user.admin?
        flash[:error] = "You do not have permission to #{request.fullpath}."
        redirect_to(root_path)
      end
    end
end
