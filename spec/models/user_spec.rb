# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foofoobarbar",
      :password_confirmation => "foofoobarbar"
    }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
end
