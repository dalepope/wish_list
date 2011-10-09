require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
  
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Log In")
    end
  end

  describe "POST 'create'" do

    describe "invalid log in" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Log In")
      end

      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "with valid email and password" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should log the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_logged_in
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    it "should log a user out" do
      test_log_in(Factory(:user))
      delete :destroy
      controller.should_not be_logged_in
      response.should redirect_to(root_path)
    end
  end
  
  describe "POST 'switch'" do
    
    before(:each) do
      @user = Factory(:user)
      @attr = { :id => @user.id }
    end
    
    describe "when not logged in" do
      
      it "should redirect to log in screen" do
        post :switch, :session => @attr
        response.should redirect_to(login_path)
      end
    end

    describe "when logged in" do

      before(:each) do
        @active_user = test_log_in(Factory(:user, :email => Factory.next(:email)))
      end

      describe "without access" do
        it "should redirect to the root path" do
          post :switch, :session => @attr
          response.should redirect_to(@active_user)
          flash.now[:error].should =~ /do not have access/i
        end
      end
      
      describe "with permission" do

        before(:each) do
          @ownership = @active_user.ownerships.build(:owned_id => @user.id)
          @ownership.save
        end

        it "should log the user in" do
          post :switch, :session => @attr
          controller.current_user.should == @user
          controller.should be_logged_in
        end

        it "should redirect to the user show page" do
          post :switch, :session => @attr
          response.should redirect_to(user_path(@user))
        end
      end
    end
  end
end
