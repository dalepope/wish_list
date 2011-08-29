# == Schema Information
#
# Table name: wish_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe WishCategory do

  before(:each) do
    @attr = {
      :name => "Kitchen"
    }
  end

  it "should create a new instance given valid attributes" do
    WishCategory.create!(@attr)
  end

  it "should reject names that are too long" do
    long_name = "a" * 21
    long_name_category = WishCategory.new(@attr.merge(:name => long_name))
    long_name_category.should_not be_valid
  end

  it "should reject duplicate names" do
    WishCategory.create!(@attr)
    duplicate_name_category = WishCategory.new(@attr)
    duplicate_name_category.should_not be_valid
  end

  it "should reject duplicate names regardless of case" do
    @attr[:name].downcase!
    WishCategory.create!(@attr)
    @attr[:name].upcase!
    duplicate_name_category = WishCategory.new(@attr)
    duplicate_name_category.should_not be_valid
  end

  it "should set none category" do
    @attr[:name] = ""
    category = WishCategory.create!(@attr)
    category.none?.should be_true
  end
  
  it "should not be none when set" do
    category = WishCategory.new(@attr)
    category.none?.should be_false
  end
end
