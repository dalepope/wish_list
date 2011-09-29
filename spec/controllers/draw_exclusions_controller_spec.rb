require 'spec_helper'

describe DrawExclusionsController do

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
      @excluded = Factory(:user, :email => Factory.next(:email))
    end

    it "should create an exclusion" do
      lambda do
        post :create, :draw_exclusion => { :excluder_id => @user, :excluded_id => @excluded }
        response.should be_redirect
      end.should change(DrawExclusion, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_log_in(Factory(:user))
      @user.toggle!(:admin)
      @excluded = Factory(:user, :email => Factory.next(:email))
      @user.draw_exclude!(@excluded)
      @exclusion = @user.draw_exclusions.find_by_excluded_id(@excluded)
    end

    it "should destroy an exclusion" do
      lambda do
        delete :destroy, :id => @exclusion
        response.should be_redirect
      end.should change(DrawExclusion, :count).by(-1)
    end
  end
end