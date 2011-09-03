require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'admin'" do
  
    it "should be successful" do
      get :admin
      response.should be_success
    end
    
    it "should have the right title" do
      get :admin
      response.should have_selector("title", :content => "Administration")
    end
    
    it "should have an add user link" do
      get :admin
      response.should have_selector("a", :href => new_user_path, :content => "Add a user")
    end
  end

end
