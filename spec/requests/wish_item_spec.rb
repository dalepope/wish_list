require 'spec_helper'

describe "WishItems" do

  before(:each) do
    @user = Factory(:user)
    visit login_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "from wish item index page" do

    before(:each) do
      visit root_path
    end
  
    it "should add a wish" do
      lambda do
        fill_in :wish_item_description, :with => "A pony"
        click_button
        response.should render_template('wish_items/index')
        response.should have_selector("div.flash.success", :content => "Added")
      end.should change(WishItem, :count).by(1)
    end
    
    it "should get back to wish item index page after failure" do
      lambda do
        click_button
      end.should_not change(WishItem, :count)
      response.should render_template('wish_items/bare_wish_item_form')
      lambda do
        fill_in :wish_item_description, :with => "A gun"
        click_button
      end.should change(WishItem, :count).by(1)
      response.should render_template('wish_items/index')
    end
  end
  
  describe "from user show page" do

    before(:each) do
      visit user_path(@user)
    end
  
    it "should add a wish" do
      lambda do
        fill_in :wish_item_description, :with => "A potato"
        click_button
        response.should render_template('users/show')
        response.should have_selector("div.flash.success", :content => "Added")
      end.should change(WishItem, :count).by(1)
    end
    
    it "should get back to user show page after failure" do
      lambda do
        click_button
      end.should_not change(WishItem, :count)
      response.should render_template('wish_items/bare_wish_item_form')
      lambda do
        fill_in :wish_item_description, :with => "One bullet"
        click_button
      end.should change(WishItem, :count).by(1)
      response.should render_template('users/show')
    end
  end
end