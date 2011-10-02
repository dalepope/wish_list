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
      
      it "should have a see users link" do
        get :admin
        response.should have_selector("a", :href => users_path, :content => "See users")
      end
      
      it "should have a see draw rules link" do
        get :admin
        response.should have_selector("a", :href => pages_draw_rules_path, :content => "See drawing rules")
      end
      
      it "should have a draw names link" do
        get :admin
        response.should have_selector("a", :href => new_draw_name_path, :content => "Draw names")
      end
      
      it "should have a see drawn names link" do
        get :admin
        response.should have_selector("a", :href => draw_names_path, :content => "See drawn names")
      end
    end
  end

  describe "GET 'draw_rules'" do
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :draw_rules
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end
    
    describe "for logged-in users" do

      before(:each) do
        @user = test_log_in(Factory(:user))
        @givers = [@user]
        19.times do
          @givers << Factory(:user, :email => Factory.next(:email))
        end
        @drawless = []
        10.times do
          @drawless << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :draw_rules
        response.should be_success
      end
      
      it "should have the right title" do
        get :draw_rules
        response.should have_selector("title", :content => "Draw Rules")
      end
      
      it "should have an element for every user" do
        get :draw_rules
        @givers.each do |user|
          response.should have_selector("li", :content => user.name)
        end
        @drawless.each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
    end
  end
end
