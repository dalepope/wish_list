class DrawExclusionsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user

  def create
    excluder = User.find(params[:draw_exclusion][:excluder_id])
    excluded = User.find(params[:draw_exclusion][:excluded_id])
    excluder.draw_exclude!(excluded)
    redirect_to draw_excluding_user_path(excluder)
  end
  
  def destroy
    exclusion = DrawExclusion.find(params[:id])
    excluder = User.find(exclusion.excluder_id)
    exclusion.delete
    redirect_to draw_excluding_user_path(excluder)
  end
end
