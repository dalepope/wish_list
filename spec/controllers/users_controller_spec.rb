require 'spec_helper'

describe UsersController do
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
      
      it "should have an in-draw checkbox" do
        get :new
        response.should have_selector("input[name='user[in_draw]'][type='checkbox']")
      end
    end
  end
  
  describe "POST 'create'" do

    describe "authentication" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foofoobarbar", :password_confirmation => "foofoobarbar" }
      end

      it "should deny access when not logged in" do
        post :create, :user => @attr
        response.should redirect_to(login_path)
      end
      
      it "should deny access when logged in as non-admin" do
        test_log_in(@user)
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
    end
  
    describe "failure" do

      before(:each) do
        @user = Factory(:user)
        @user.admin = true
        test_log_in(@user)
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
        @user = Factory(:user)
        @user.admin = true
        test_log_in(@user)
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

    describe "for non-logged in users" do
    
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
      
      it "should not show the link to change profile image" do
        get :show, :id => @user
        response.should_not have_selector("a", :content => "Change image")
      end
      
      it "should not show the Christmas draw status" do
        get :show, :id => @user
        response.should_not have_selector("p", :content => "Christmas")
      end

      it "should not show the wish item form" do
        get :show, :id => @user
        response.should_not have_selector("td", :content => "Description")
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
        response.should have_selector("span.description", :content => wish1.description)
        response.should have_selector("a", :href => wish1.url, :content => wish1.description)
        response.should have_selector("span.description", :content => wish2.description)
        response.should have_selector("a", :href => wish2.url, :content => wish2.description)
      end
      
      it "should show the user's wishes without urls" do
        category = Factory(:wish_category, :name => "Book")
        wish1 = Factory(:wish_item,
                        :user => @user,
                        :description => "Foo bar", 
                        :url => nil,
                        :category => category)
        wish2 = Factory(:wish_item,
                        :user => @user,
                        :description => "Baz quux",
                        :url => "",
                        :category => category)
        get :show, :id => @user
        response.should_not have_selector("a", :content => wish1.description)
        response.should_not have_selector("a", :content => wish2.description)
      end
      
      it "should show the user's wishes with blank categories" do
        category = Factory(:wish_category, :name => "")
        wish1 = Factory(:wish_item,
                        :user => @user,
                        :description => "Foo bar", 
                        :url => "http://jim.com",
                        :category => category)
        get :show, :id => @user
        response.should_not have_selector("span.description", :content => wish1.category.name)
        response.should have_selector("span.description", :content => wish1.description)
        response.should have_selector("a", :href => wish1.url, :content => wish1.description)
      end
    end
    
    describe "for own logged-in user" do
    
      before(:each) do
        test_log_in(@user)
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
      
      it "should show the link to change profile image" do
        get :show, :id => @user
        response.should have_selector("a", :content => "Change image")
      end

      it "should not show the Christmas draw status" do
        get :show, :id => @user
        response.should_not have_selector("p", :content => "the Christmas draw")
      end

      it "should show the wish item form" do
        get :show, :id => @user
        response.should have_selector("td", :content => "Description")
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
        response.should have_selector("span.description", :content => wish1.description)
        response.should have_selector("a", :href => wish1.url, :content => wish1.description)
        response.should have_selector("span.description", :content => wish2.description)
        response.should have_selector("a", :href => wish2.url, :content => wish2.description)
      end
      
      describe "in the draw" do
      
        before(:each) do
          @user.toggle!(:in_draw)
        end
        
        it "should show Christmas draw status" do
          get :show, :id => @user
          response.should have_selector("p", :content => "Christmas")
          response.should have_selector("p", :content => "No name")
        end
        
        it "should show the drawn name" do
          receiver = Factory(:user, :email => Factory.next(:email))
          drawn_name = DrawnName.new
          drawn_name.giver_id = @user.id
          drawn_name.receiver_id = receiver.id
          @user.drawn_name = drawn_name
          get :show, :id => @user
          response.should have_selector("p", :content => "Christmas")
          response.should have_selector("p", :content => receiver.name)
        end
      end
    end
    
    describe "for logged in users viewing others" do
    
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_log_in(wrong_user)
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
      
      it "should not show the link to change profile image" do
        get :show, :id => @user
        response.should_not have_selector("a", :content => "Change image")
      end

      it "should not show the Christmas draw status" do
        get :show, :id => @user
        response.should_not have_selector("p", :content => "Christmas")
      end

      it "should not show the wish item form" do
        get :show, :id => @user
        response.should_not have_selector("td", :content => "Description")
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
        response.should have_selector("span.description", :content => wish1.description)
        response.should have_selector("a", :href => wish1.url, :content => wish1.description)
        response.should have_selector("span.description", :content => wish2.description)
        response.should have_selector("a", :href => wish2.url, :content => wish2.description)
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end

    describe "for logged in non-admins" do
    
      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit Account")
      end
      
      it "should not have the name field" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='user[name]'][type='text']")
      end
      
      it "should show the name" do
        get :edit, :id => @user
        response.should have_selector("h3", :content => @user.name)
      end
      
      it "should have an old password field" do
        get :edit, :id => @user
        response.should have_selector("input[name='old_password'][type='password']")
      end

      it "should not have an admin checkbox" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='user[admin]'][type='checkbox']")
      end
      
      it "should not have an in-draw checkbox" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='user[in_draw]'][type='checkbox']")
      end
    end
    
    describe "for logged in admins" do

      before(:each) do
        @user.toggle!(:admin)
      end
      
      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit Account")
      end

      it "should have the name field" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[name]'][type='text']")
      end
      
      it "should not have an old password field" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='old_password'][type='password']")
      end
      
      it "should have an admin checkbox" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[admin]'][type='checkbox']")
      end
      
      it "should have an in-draw checkbox" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[in_draw]'][type='checkbox']")
      end
    end
  end
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_log_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit Account")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbarbazbaz", :password_confirmation => "barbarbazbaz" }
        @old_password = @user.password
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr, :old_password => @old_password
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should change the user's attributes without new password" do
        @attr.merge({ :password => "", :password_confirmation => "" })
        put :update, :id => @user, :user => @attr, :old_password => @old_password
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end
      
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr, :old_password => @old_password
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr, :old_password => @old_password
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-logged-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(login_path)
      end
    end
    
    describe "for logged-in non-admins" do

      describe "editing the wrong user" do
      
        before(:each) do
          wrong_user = Factory(:user, :email => "user@example.net")
          test_log_in(wrong_user)
        end

        it "should require matching users for 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(root_path)
        end

        it "should require matching users for 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(root_path)
        end
      end
      
      describe "editing themselves" do
      
        it "should require current password" do
          test_log_in(@user)
          put :update, :id => @user, :user => @attr, :old_password => "wrong"
          flash[:error].should =~ /does not match/
        end
      end
    end
    
    describe "for logged-in admins" do

      before(:each) do
        admin_user = Factory(:user, :email => "user@example.net")
        test_log_in(admin_user)
        admin_user.toggle!(:admin)
      end

      it "should 'edit' any user" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should 'update' any user" do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbarbazbaz", :password_confirmation => "barbarbazbaz" }
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end
    end
  end

  describe "GET 'draw_excluding'" do
  
    before(:each) do
      @user = Factory(:user)
    end
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :draw_excluding, :id => @user
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for wrong users" do
      it "should deny access" do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_log_in(wrong_user)
        get :draw_excluding, :id => @user
        response.should redirect_to(root_path)
        flash[:error].should =~ /not an owner/i
      end
    end
    
    describe "for logged-in users" do

      before(:each) do
        @user = test_log_in(@user)
      end

      it "should be successful" do
        get :draw_excluding, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :draw_excluding, :id => @user
        response.should have_selector("title", :content => "Exclusions")
      end
      
      describe "not in the draw" do
        it "should say not in the draw" do
          get :draw_excluding, :id => @user
          response.should have_selector("p", :content => "not in the Christmas draw")
        end
      end
      
      describe "in the draw" do
      
        before(:each) do
          @user.toggle!(:in_draw)
        end

        describe "with no exclusions" do
          it "should say any name can be drawn" do
            get :draw_excluding, :id => @user
            response.should have_selector("p", :content => "can draw anyone's name")
          end
        end
      
        describe "with exclusions" do
        
          before(:each) do
            @excluded1 = Factory(:user, :email => Factory.next(:email))
            @user.draw_exclude!(@excluded1)
          end
        
          it "should list the exclusions" do
            excluded2 = Factory(:user, :email => Factory.next(:email))
            @user.draw_exclude!(excluded2)
            get :draw_excluding, :id => @user
            response.should have_selector("p", :content => "cannot draw the following")
            response.should have_selector("li", :content => @excluded1.name)
            response.should have_selector("li", :content => excluded2.name)
          end
          
          it "should not list additional users" do
            spare_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
            spare_user.toggle!(:in_draw)
            get :draw_excluding, :id => @user
            response.should_not have_selector("li", :content => spare_user.name)
          end
          
          it "should not have exclude buttons" do
            get :draw_excluding, :id => @user
            response.should_not have_selector("input", :type => "submit", :value => "draw")
          end
        end
      end
    end
      
    describe "for logged-in admins" do

      before(:each) do
        @admin = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        @admin = test_log_in(@admin)
        @admin.toggle!(:admin)
      end

      it "should be successful" do
        get :draw_excluding, :id => @user
        response.should be_success
      end
      
      describe "not in the draw" do
        it "should say not in the draw" do
          get :draw_excluding, :id => @user
          response.should have_selector("p", :content => "not in the Christmas draw")
        end
      end
      
      describe "in the draw" do
      
        before(:each) do
          @user.toggle!(:in_draw)
        end

        describe "with exclusions" do
        
          before(:each) do
            @excluded1 = Factory(:user, :email => Factory.next(:email))
            @excluded1.toggle!(:in_draw)
            @user.draw_exclude!(@excluded1)
            @spare_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
            @spare_user.toggle!(:in_draw)
          end
        
          it "should list the exclusions" do
            get :draw_excluding, :id => @user
            response.should have_selector("p", :content => "cannot draw the following")
            response.should have_selector("li", :content => @excluded1.name)
          end
          
          it "should list additional users" do
            get :draw_excluding, :id => @user
            response.should have_selector("li", :content => @spare_user.name)
          end
          
          it "should have exclude buttons" do
            get :draw_excluding, :id => @user
            response.should have_selector("input", :type => "submit", :value => "Can draw")
            response.should have_selector("input", :type => "submit", :value => "Cannot draw")
          end
        end
      end
    end
  end
    
  describe "GET 'ownerships'" do
  
    before(:each) do
      @user = Factory(:user)
    end
  
    describe "for non-logged-in users" do
      it "should deny access" do
        get :ownerships, :id => @user
        response.should redirect_to(login_path)
        flash[:notice].should =~ /log in/i
      end
    end

    describe "for wrong users" do
      it "should deny access" do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_log_in(wrong_user)
        get :ownerships, :id => @user
        response.should redirect_to(root_path)
        flash[:error].should =~ /do not have permission/i
      end
    end
    
    describe "for logged-in users" do

      before(:each) do
        @user = test_log_in(@user)
      end

      it "should deny access" do
        get :ownerships, :id => @user
        response.should redirect_to(root_path)
        flash[:error].should =~ /do not have permission/i
      end
    end
      
    describe "for logged-in admins" do

      before(:each) do
        @admin = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        @admin = test_log_in(@admin)
        @admin.toggle!(:admin)
      end

      it "should be successful" do
        get :ownerships, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :ownerships, :id => @user
        response.should have_selector("title", :content => "Ownerships")
      end
      
      describe "with owned" do
      
        before(:each) do
          @owned1 = Factory(:user, :email => Factory.next(:email))
          @user.own!(@owned1)
          @spare_user = Factory(:user, :name => Factory.next(:name), :email => Factory.next(:email))
        end
      
        it "should list the owned" do
          get :ownerships, :id => @user
          response.should have_selector("p", :content => "owns the following")
          response.should have_selector("li", :content => @owned1.name)
        end
        
        it "should list additional users" do
          get :ownerships, :id => @user
          response.should have_selector("li", :content => @spare_user.name)
        end
        
        it "should have own buttons" do
          get :ownerships, :id => @user
          response.should have_selector("input", :type => "submit", :value => "Own")
          response.should have_selector("input", :type => "submit", :value => "Unown")
        end
      end
    end
  end
end
