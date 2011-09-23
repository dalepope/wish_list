require 'spec_helper'

describe DrawNamesController do
  render_views

  describe "GET 'new'" do
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :new
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for logged-in non-admins" do
      it "should deny access" do
        @user = test_log_in(Factory(:user))
        get :new
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
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Draw Names Status")
      end
    end
  end

end
