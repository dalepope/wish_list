require 'spec_helper'

describe OwnershipsController do

  describe "access control" do

    it "should require login for create" do
      post :create
      response.should redirect_to(login_path)
    end

    it "should require logged in admin for create" do
      @user = test_log_in(Factory(:user))
      post :create
      response.should redirect_to(root_path)
      flash[:error].should =~ /do not have permission/i
    end

    it "should require login for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(login_path)
    end
    
    it "should require logged in admin for destroy" do
      @user = test_log_in(Factory(:user))
      post :destroy, :id => 1
      response.should redirect_to(root_path)
      flash[:error].should =~ /do not have permission/i
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_log_in(Factory(:user))
      @user.toggle!(:admin)
      @owned = Factory(:user, :email => Factory.next(:email))
    end

    it "should create an ownership" do
      lambda do
        post :create, :ownership => { :owner_id => @user, :owned_id => @owned }
        response.should be_redirect
      end.should change(Ownership, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_log_in(Factory(:user))
      @user.toggle!(:admin)
      @owned = Factory(:user, :email => Factory.next(:email))
      @user.own!(@owned)
      @ownership = @user.ownerships.find_by_owned_id(@owned)
    end

    it "should destroy an ownership" do
      lambda do
        delete :destroy, :id => @ownership
        response.should be_redirect
      end.should change(Ownership, :count).by(-1)
    end
  end
end