require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
  
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Add User")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    
    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
    
    it "should have an admin checkbox" do
      get :new
      response.should have_selector("input[name='user[admin]'][type='checkbox']")
    end
  end
  
  describe "POST 'create'" do
  
    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Add User")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should clear the password fields" do
        populated_password = @attr.merge(:password => "shouldclear", :password_confirmation => "shouldclear")
        post :create, :user => populated_password
        response.should have_selector("input[name='user[password]'][type='password'][value='']")
        response.should have_selector("input[name='user[password_confirmation]'][type='password'][value='']")
      end
    end
    
    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foofoobarbar", :password_confirmation => "foofoobarbar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user index page" do
        post :create, :user => @attr
        response.should redirect_to(users_path)
      end
    end
  end

  describe "GET 'index'" do
  
    before(:each) do
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
      response.should have_selector("title", :content => "Wishers")
    end
    
    it "should have an element for each user" do
      get :index
      @users.each do |user|
        response.should have_selector("li", :content => user.name)
      end
    end
  end

  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should show the user's wishes" do
      category = Factory(:wish_category, :name => "Book")
      wish1 = Factory(:wish_item,
                      :user => @user,
                      :description => "Foo bar", 
                      :url => "http://jim.com",
                      :category => category)
      wish2 = Factory(:wish_item,
                      :user => @user,
                      :description => "Baz quux",
                      :url => "http://zumbo.com",
                      :category => category)
      get :show, :id => @user
      response.should have_selector("span.description", :content => wish1.category.name)
      response.should have_selector("span.description", :content => wish1.description)
      response.should have_selector("a", :href => wish1.url)
      response.should have_selector("span.description", :content => wish2.category.name)
      response.should have_selector("span.description", :content => wish2.description)
      response.should have_selector("a", :href => wish1.url)
    end
  end
end
