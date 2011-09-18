require 'spec_helper'

describe DrawnName do

  before(:each) do
    @giver = Factory(:user)
    @receiver = Factory(:user, :email => Factory.next(:email))
    @drawn_name = DrawnName.new
    @drawn_name.giver = @giver
    @drawn_name.receiver = @receiver
  end
  
  it "should create a new instance given valid attributes" do
    @drawn_name.save!
  end
  
  describe "giver/receiver methods" do
  
    before(:each) do
      @drawn_name.save
    end

    it "should have a giver attribute" do
      @drawn_name.should respond_to(:giver)
    end

    it "should have the right giver" do
      @drawn_name.giver.should == @giver
    end

    it "should have a receiver attribute" do
      @drawn_name.should respond_to(:receiver)
    end

    it "should have the right receiver user" do
      @drawn_name.receiver.should == @receiver
    end
  end
  
  describe "validations" do
  
    it "should require a giver_id" do
      @drawn_name.giver_id = nil
      @drawn_name.should_not be_valid
    end

    it "should require a receiver_id" do
      @drawn_name.receiver_id = nil
      @drawn_name.should_not be_valid
    end
  end
end
