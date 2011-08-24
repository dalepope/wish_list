require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    render_views
  
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Add User")
    end
  end

end
