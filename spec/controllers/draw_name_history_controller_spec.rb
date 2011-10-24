require 'spec_helper'

describe DrawNameHistoryController do

  describe "POST 'create'" do

    describe "authentication" do

      before(:each) do
        @user = Factory(:user)
      end

      it "should deny access when not logged in" do
        post :create
        response.should redirect_to(login_path)
      end
      
      it "should deny access when logged in as non-admin" do
        test_log_in(@user)
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
    end
  
    describe "success" do

      before(:each) do
        @user = Factory(:user)
        @user.admin = true
        test_log_in(@user)
        drawn = DrawnName.new
        drawn.giver = @user
        drawn.receiver = @user
        drawn.save!
      end

      it "should show success" do
        post :create
        flash[:success].should =~ /history stored/i
      end
    end
  end

end
