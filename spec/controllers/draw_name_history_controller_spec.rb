require 'spec_helper'

describe DrawNameHistoryController do
  render_views

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
  
    describe "success" do

      before(:each) do
        @user = Factory(:user)
        @user.admin = true
        test_log_in(@user)
        drawn = DrawnName.new
        drawn.giver = @user
        drawn.receiver = @user
        drawn.save!
      end

      it "should show success" do
        post :create
        flash[:success].should =~ /history stored/i
      end
    end
  end

  describe "GET 'view'" do
    describe "for non-logged-in users" do
      it "should deny access" do
        get :view
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for logged-in users" do
    
      before(:each) do
        @user = test_log_in(Factory(:user))
        @users = [ @user ]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
          drawn_name = DrawnNameHistory.new
          drawn_name.year = 2011
          drawn_name.giver = @users.last
          drawn_name.receiver = Factory(:user, :email => Factory.next(:email))
          drawn_name.save!
        end
      end
      
      it "should be successful" do
        get :view
        response.should be_success
      end
      
      it "should have the right title" do
        get :view
        response.should have_selector("title", :content => "Name Draw History")
      end
      
      it "should have an element for each user" do
        get :view
        @users.each do |user|
          response.should have_selector("td", :content => user.name)
        end
      end
    end
  end
end
