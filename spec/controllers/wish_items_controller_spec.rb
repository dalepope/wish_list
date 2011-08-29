require 'spec_helper'

describe WishItemsController do
  render_views

  describe "GET 'index'" do
  
    before(:each) do
      category1 = Factory(:wish_category, :name => "Book")
      category2 = Factory(:wish_category, :name => "DVD")
      @users = []
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
      
    it "should be successful" do
      get :index
      response.should be_success
    end
    
    it "should have the right title" do
      get :index
      response.should have_selector("title", :content => "Wish Lists")
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
  end
end
