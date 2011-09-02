require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Wish Lists")
  end

  it "should have a add-user page at '/users/new'" do
    get '/users/new'
    response.should have_selector('title', :content => "Add User")
  end
  
  describe "when not logged in" do
  
    it "should have a log in link" do
      visit root_path
      response.should have_selector("a", :href => login_path,
                                         :content => "Log In")
    end
  end

  describe "when logged in" do

    before(:each) do
      @user = Factory(:user)
      visit login_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it "should have a log out link" do
      visit root_path
      response.should have_selector("a", :href => logout_path,
                                         :content => "Log Out")
    end
  end
end