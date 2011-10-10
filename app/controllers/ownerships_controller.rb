class OwnershipsController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user

  def create
    owner = User.find(params[:ownership][:owner_id])
    owned = User.find(params[:ownership][:owned_id])
    owner.own!(owned)
    redirect_to ownerships_user_path(owner)
  end
  
  def destroy
    ownership = Ownership.find(params[:id])
    owner = User.find(ownership.owner_id)
    ownership.delete
    redirect_to ownerships_user_path(owner)
  end
end
