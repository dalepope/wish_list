require 'spec_helper'

describe WishItemsController do
  render_views

  describe "GET 'index'" do
  
    before(:each) do
      category1 = Factory(:wish_category, :name => "Book")
      category2 = Factory(:wish_category, :name => "DVD")
      @users = [ Factory(:user) ]
      20.times do |i|
        @users << Factory(:user, 
                          :name => Factory.next(:name),
                          :email => Factory.next(:email))
        Factory(:wish_item,
                :user => @users[i-1],
                :description => Factory.next(:description), 
                :category => category1)
        Factory(:wish_item,
                :user => @users[i-1],
                :description => Factory.next(:description),
                :category => category2)
      end
    end
  
    describe "when not logged in" do
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Wish Lists")
      end
      
      it "should not have a description field" do
        get :index
        response.should_not have_selector("input[name='wish_item[description]'][type='text']")
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("h2", :content => user.name)
        end
      end
      
      it "should have an element for each wish" do
        get :index
        @users.each do |user|
          user.wish_items.each do |wish|
            response.should have_selector("li", :content => wish.description)
          end
        end
      end
      
      it "should not have delete link" do
        get :index
        response.should_not have_selector("a", :content => "delete")
      end

    end
    
    describe "when logged in" do

      before(:each) do
        @user = @users[0]
        test_log_in(@user)
      end
    
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Wish Lists")
      end
      
      it "should have a description field" do
        get :index
        response.should have_selector("textarea[name='wish_item[description]']")
      end

      it "should have a url field" do
        get :index
        response.should have_selector("input[name='wish_item[url]'][type='text']")
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("h2", :content => user.name)
        end
      end
      
      it "should have an element for each wish" do
        get :index
        @users.each do |user|
          user.wish_items.each do |wish|
            response.should have_selector("li", :content => wish.description)
          end
        end
      end
      
      it "should have delete link" do
        get :index
        response.should have_selector("a", :content => "delete")
      end
    end
  end
  
  describe "POST 'create'" do

    describe "authentication" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :description => "Latest gadget" }
      end

      it "should deny access when not logged in" do
        post :create, :wish_item => @attr
        response.should redirect_to(login_path)
      end
    end
  
    describe "failure" do

      before(:each) do
        @user = Factory(:user)
        test_log_in(@user)
        @attr = { :description => "", :url => "" }
      end

      it "should not create a wish item" do
        lambda do
          post :create, :wish_item => @attr
        end.should_not change(WishItem, :count)
      end

      it "should render the bare form page" do
        post :create, :wish_item => @attr
        response.should render_template('bare_wish_item_form')
      end
    end
    
    describe "success" do

      before(:each) do
        @user = Factory(:user)
        test_log_in(@user)
        @attr = { :description => "Latest gadget" }
      end

      it "should create a wish item" do
        lambda do
          post :create, :wish_item => @attr
        end.should change(WishItem, :count).by(1)
      end

      it "should redirect to the root page" do
        post :create, :wish_item => @attr
        response.should redirect_to(root_path)
      end
      
      it "should have a flash message" do
        post :create, :wish_item => @attr
        flash[:success].should =~ /added wish/i
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_log_in(wrong_user)
        @wish_item = Factory(:wish_item, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @wish_item
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_log_in(Factory(:user))
        @wish_item = Factory(:wish_item, :user => @user)
      end

      it "should destroy the wish item" do
        lambda do
          delete :destroy, :id => @wish_item
        end.should change(WishItem, :count).by(-1)
      end
    end
  end

  describe "GET 'feed'" do
  
    before(:each) do
      category1 = Factory(:wish_category, :name => "Book")
      category2 = Factory(:wish_category, :name => "DVD")
      @users = [ ]
      4.times do |i|
        @users << Factory(:user, 
                          :name => Factory.next(:name),
                          :email => Factory.next(:email))
        Factory(:wish_item,
                :user => @users[i],
                :description => Factory.next(:description), 
                :category => category1)
        Factory(:wish_item,
                :user => @users[i],
                :description => Factory.next(:description),
                :category => category2)
      end
    end
  
    describe "in atom format" do
      it "should be successful" do
        get :feed, :format => 'atom'
        response.should be_success
      end
      
      it "should have the right title" do
        get :feed, :format => 'atom'
        response.should have_selector("title", :content => "Wish Lists")
      end
      
      it "should have an element for each user" do
        get :feed, :format => 'atom'
        @users.each do |user|
          response.should have_selector("name", :content => user.name)
        end
      end
      
      it "should have a title element for each wish" do
        get :feed, :format => 'atom'
        @users.each do |user|
          user.wish_items.each do |wish|
            response.should have_selector("title", :content => user.name)
            response.should have_selector("title", :content => wish.description)
          end
        end
      end
      
      it "should have a content element for each wish" do
        get :feed, :format => 'atom'
        @users.each do |user|
          user.wish_items.each do |wish|
            response.should have_selector("content", :content => user.name)
            response.should have_selector("content", :content => wish.description)
          end
        end
      end
      
      it "should have a url for each wish" do
        get :feed, :format => 'atom'
        @users.each do |user|
          user.wish_items.each do |wish|
            response.should have_selector("url", :content => wish.id.to_s)
          end
        end
      end
    end
    
    describe "in rss format" do
      it "should redirect to atom" do
        get :feed, :format => 'rss'
        response.should be_redirect
      end
    end
    
    describe "named routes" do
      it "should route from /feed" do
        { :get => '/feed' }.should route_to(:controller => 'wish_items', :action => 'feed', :format => 'atom')
      end
      
      it "should route from /feed.atom" do
        { :get => '/feed.atom' }.should route_to(:controller => 'wish_items', :action => 'feed', :format => 'atom')
      end
      
      it "should route from /feed.rss" do
        { :get => '/feed.rss' }.should route_to(:controller => 'wish_items', :action => 'feed', :format => 'rss')
      end
    end
  end
end
