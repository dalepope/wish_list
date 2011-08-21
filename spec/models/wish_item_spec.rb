# == Schema Information
#
# Table name: wish_items
#
#  id          :integer         not null, primary key
#  description :text
#  url         :string(255)
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe WishItem do

  before(:each) do
    @category = Factory(:wish_category)
    @user = Factory(:user)
    @attr = {
      :description => "Example item",
      :url => "http://www.example.com/item",
      :category_id => @category.id,
      :user_id => @user.id
    }
  end
  
  it "should create a new instance given valid attributes" do
    WishItem.create!(@attr)
  end
  
  it "should require a description" do
    no_description_item = WishItem.new(@attr.merge(:description => ""))
    no_description_item.should_not be_valid
  end
  
  it "should accept long descriptions" do
    long_description = "a" * 4000
    long_description_item = WishItem.new(@attr.merge(:description => long_description))
    long_description_item.should be_valid
  end

  it "should reject descriptions that are too long" do
    long_description = "a" * 4001
    long_description_item = WishItem.new(@attr.merge(:description => long_description))
    long_description_item.should_not be_valid
  end

  it "should not require a url" do
    no_url_item = WishItem.new(@attr.merge(:url => ""))
    no_url_item.should be_valid
  end
  
  it "should accept long urls" do
    long_url = "http://" + ("a" * 1993)
    long_url_item = WishItem.new(@attr.merge(:url => long_url))
    long_url_item.should be_valid
  end
  
  it "should reject urls that are too long" do
    long_url = "http://" + ("a" * 1994)
    long_url_item = WishItem.new(@attr.merge(:url => long_url))
    long_url_item.should_not be_valid
  end

  it "should accept valid urls" do
    urls = %w[http://www https://www HTTP://www http://www.com http://www.com/fruit/super%20banana]
    urls.each do |url|
      url_item = WishItem.new(@attr.merge(:url => url))
      url_item.should be_valid
    end
  end
  
  it "should reject invalid urls" do
    urls = %w[a http:// http://www<script>]
    urls.each do |url|
      url_item = WishItem.new(@attr.merge(:url => url))
      url_item.should_not be_valid
    end
  end

  it "should require a category_id" do
    no_category_item = WishItem.new(@attr.merge(:category_id => nil))
    no_category_item.should_not be_valid
  end

  it "should require a user_id" do
    no_user_item = WishItem.new(@attr.merge(:user_id => nil))
    no_user_item.should_not be_valid
  end
end
