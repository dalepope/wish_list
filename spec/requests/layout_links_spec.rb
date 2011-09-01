require 'spec_helper'

describe "LayoutLinks" do

  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Wish Lists")
  end

  it "should have a add-user page at '/users/new'" do
    get '/users/new'
    response.should have_selector('title', :content => "Add User")
  end
  
end