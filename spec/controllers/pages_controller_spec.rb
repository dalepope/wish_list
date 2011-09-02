require 'spec_helper'

describe PagesController do

  describe "GET 'admin'" do
    it "should be successful" do
      get 'admin'
      response.should be_success
    end
  end

end
