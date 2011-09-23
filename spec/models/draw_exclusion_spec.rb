require 'spec_helper'

describe DrawExclusion do

  before(:each) do
    @excluder = Factory(:user)
    @excluded = Factory(:user, :email => Factory.next(:email))
    
    @draw_exclusion = @excluder.draw_exclusions.build(:excluded_id => @excluded.id)
  end
  
  it "should create a new instance given valid attributes" do
    @draw_exclusion.save!
  end
  
  describe "validations" do
  
    it "should require a excluder_id" do
      @draw_exclusion.excluder_id = nil
      @draw_exclusion.should_not be_valid
    end

    it "should require a excluded_id" do
      @draw_exclusion.excluded_id = nil
      @draw_exclusion.should_not be_valid
    end
  end
  
  describe "exclude methods" do
  
    before(:each) do
      @draw_exclusion.save
    end
    
    it "should have an excluder attribute" do
      @draw_exclusion.should respond_to(:excluder)
    end
    
    it "should have the right excluder" do
      @draw_exclusion.excluder.should == @excluder
    end
    
    it "should have an excluded attribute" do
      @draw_exclusion.should respond_to(:excluded)
    end
    
    it "should have an excluded attribute" do
      @draw_exclusion.excluded.should == @excluded
    end
  end
end
