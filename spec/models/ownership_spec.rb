require 'spec_helper'

describe Ownership do

  before(:each) do
    @owner = Factory(:user)
    @owned = Factory(:user, :email => Factory.next(:email))
    
    @ownership = @owner.ownerships.build(:owned_id => @owned.id)
  end
  
  it "should create a new instance given valid attributes" do
    @ownership.save!
  end
  
  describe "validations" do
  
    it "should require a owner_id" do
      @ownership.owner_id = nil
      @ownership.should_not be_valid
    end

    it "should require a owned_id" do
      @ownership.owned_id = nil
      @ownership.should_not be_valid
    end
  end
  
  describe "own methods" do
  
    before(:each) do
      @ownership.save
    end
    
    it "should have an owner attribute" do
      @ownership.should respond_to(:owner)
    end
    
    it "should have the right owner" do
      @ownership.owner.should == @owner
    end
    
    it "should have an owned attribute" do
      @ownership.should respond_to(:owned)
    end
    
    it "should have an owned attribute" do
      @ownership.owned.should == @owned
    end
  end
end
