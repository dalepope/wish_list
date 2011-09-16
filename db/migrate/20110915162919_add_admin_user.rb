class AddAdminUser < ActiveRecord::Migration
  def self.up
    user = User.new(:email => "admin@mysite.com",
                 :name => "Admin",
                 :password => "defaultpassword")
    user.toggle!(:admin)
    user.save
  end

  def self.down
    user = User.find_by_name('Admin')
    user.destroy
  end
end
