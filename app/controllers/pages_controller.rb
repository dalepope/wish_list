class PagesController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user

  def admin
    @title = "Administration"
  end
  
  def draw_names_status
    @title = "Draw Names Status"
  end

  private
  
    def admin_user
      unless current_user.admin?
        flash[:error] = "You do not have permission to #{request.fullpath}."
        redirect_to(root_path)
      end
    end
end
