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

  describe "POST 'create'" do

    describe "authentication" do

      before(:each) do
        @user = Factory(:user)
      end

      it "should deny access when not logged in" do
        post :create
        response.should redirect_to(login_path)
      end
      
      it "should deny access when logged in as non-admin" do
        test_log_in(@user)
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
    end
  
    describe "success (most of the time)" do

      before(:each) do
        @user = Factory(:user)
        @user.admin = true
        test_log_in(@user)
      end

      it "should show success" do
        post :create
        flash[:success].should =~ /names drawn/i
      end
    end
  end

  describe "GET 'index'" do
  
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
        @users = []
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Drawn Names")
      end
      
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("td", :content => user.name)
        end
      end
    end
  end
end
