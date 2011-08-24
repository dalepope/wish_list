require 'spec_helper'

describe "LayoutLinks" do

  it "should have a add-user page at '/users/new'" do
    get '/users/new'
    response.should have_selector('title', :content => "Add User")
  end
  
end