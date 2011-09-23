require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'admin'" do
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :admin
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end
    
    describe "for logged-in non-admins" do
      it "should deny access" do
        @user = test_log_in(Factory(:user))
        get :admin
        response.should redirect_to(root_path)
        flash[:error].should =~ /do not have permission/i
      end
    end
    
    describe "for logged-in admins" do

      before(:each) do
        @user = test_log_in(Factory(:user))
        @user.toggle!(:admin)
      end
      
      it "should be successful" do
        get :admin
        response.should be_success
      end
      
      it "should have the right title" do
        get :admin
        response.should have_selector("title", :content => "Administration")
      end
      
      it "should have an add user link" do
        get :admin
        response.should have_selector("a", :href => new_user_path, :content => "Add a user")
      end
      
      it "should have a draw names link" do
        get :admin
        response.should have_selector("a", :href => new_draw_name_path, :content => "Draw names")
      end
    end
  end

  describe "GET 'draw_names_status'" do
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :draw_names_status
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end
    
    describe "for logged-in non-admins" do
      it "should deny access" do
        @user = test_log_in(Factory(:user))
        get :draw_names_status
        response.should redirect_to(root_path)
        flash[:error].should =~ /do not have permission/i
      end
    end
    
    describe "for logged-in admins" do

      before(:each) do
        @user = test_log_in(Factory(:user))
        @user.toggle!(:admin)
      end
      
      it "should be successful" do
        get :draw_names_status
        response.should be_success
      end
      
      it "should have the right title" do
        get :draw_names_status
        response.should have_selector("title", :content => "Draw Names Status")
      end
    end
  end
end
