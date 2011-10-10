# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foofoobarbar",
      :password_confirmation => "foofoobarbar"
    }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  describe "name validations" do
  
    it "should require a name" do
      no_name_user = User.new(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
    end

    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end
  end
  
  describe "email validations" do
  
    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
    
    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
    
    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 11
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

    it "should not reject blank passwords when encrypted password is set" do
      user = User.create!(@attr)
      hash = @attr.merge(:password => "", :password_confirmation => "")
      user.update_attributes!(hash)
      user.should be_valid
    end
    
    it "should reject blank passwords when confirmation does not match" do
      user = User.create!(@attr)
      hash = @attr.merge(:password => "", :password_confirmation => "invalid")
      user.update_attributes(hash)
      user.should_not be_valid
    end
  end
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
  
    describe "has_password? method" do
    
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr.merge(:admin => true))
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

  describe "in_draw attribute" do

    before(:each) do
      @user = User.create!(@attr.merge(:in_draw => true))
    end

    it "should respond to in_draw" do
      @user.should respond_to(:in_draw)
    end

    it "should not be in the draw by default" do
      @user.should_not be_in_draw
    end

    it "should be convertible to be in the draw" do
      @user.toggle!(:in_draw)
      @user.should be_in_draw
    end
  end
  
  describe "wish_item associations" do

    before(:each) do
      category = Factory(:wish_category, :name => "Book")
      @user = User.create(@attr)
      @wish1 = Factory(:wish_item,
                      :user => @user,
                      :description => "Foo bar", 
                      :url => "http://jim.com",
                      :category => category,
                      :created_at => 1.day.ago)
      @wish2 = Factory(:wish_item,
                      :user => @user,
                      :description => "Baz quux",
                      :url => "http://zumbo.com",
                      :category => category,
                      :created_at => 1.hour.ago)
    end

    it "should have a wish_items attribute" do
      @user.should respond_to(:wish_items)
    end
    
    it "should have the right wish_items in the right order" do
      @user.wish_items.should == [@wish2, @wish1]
    end
    
    it "should destroy associated wish_items" do
      @user.destroy
      [@wish1, @wish2].each do |wish|
        WishItem.find_by_id(wish.id).should be_nil
      end
    end
  end
  
  describe "drawn name" do
  
    before(:each) do
      @user = User.create!(@attr)
      @receiver = Factory(:user)
    end
    
    it "should have a drawn_name method" do
      @user.should respond_to(:drawn_name)
    end
  end

  describe "draw exclusions" do
    
    before(:each) do
      @user = User.create!(@attr)
      @excluded = Factory(:user)
    end
    
    it "should have a draw_exclusions method" do
      @user.should respond_to(:draw_exclusions)
    end
    
    it "should have a draw_excluding method" do
      @user.should respond_to(:draw_excluding)
    end
    
    it "should have a draw_exclude! method" do
      @user.should respond_to(:draw_exclude!)
    end
    
    it "should have a draw_excludable method" do
      User.should respond_to(:draw_excludable)
    end

    it "should exclude another user" do
      @user.draw_exclude!(@excluded)
      @user.should be_draw_excluding(@excluded)
    end

    it "should include the excluded user in the excluding array" do
      @user.draw_exclude!(@excluded)
      @user.draw_excluding.should include(@excluded)
    end
    
    it "should have a draw_include! method" do
      @user.should respond_to(:draw_include!)
    end

    it "should include another user" do
      @user.draw_exclude!(@excluded)
      @user.draw_include!(@excluded)
      @user.should_not be_draw_excluding(@excluded)
    end
  end
  
  describe "ownerships" do
  
    before(:each) do
      @user = User.create!(@attr)
      @owned = Factory(:user)
    end
    
    it "should have a owned method" do
      @user.should respond_to(:owned)
    end
    
    it "should have an owns? method" do
      @user.should respond_to(:owns?)
    end
    
    it "should have an ownable method" do
      User.should respond_to(:ownable)
    end
    
    it "should have an own! method" do
      @user.should respond_to(:own!)
    end
    
    it "should own another user" do
      @user.own!(@owned)
      @user.should be_owns(@owned)
    end

    it "should include the owned user in the ownerships array" do
      @user.own!(@owned)
      @user.owned.should include(@owned)
    end
    
    it "should have an unown! method" do
      @user.should respond_to(:unown!)
    end

    it "should own another user" do
      @user.own!(@owned)
      @user.unown!(@owned)
      @user.should_not be_owns(@owned)
    end
  end
end
