# == Schema Information
#
# Table name: wish_items
#
#  id          :integer         not null, primary key
#  description :text
#  url         :string(255)
#  category_id :integer
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class WishItem < ActiveRecord::Base
  attr_accessible :description, :url, :category_id, :user_id
  
  validates :description, :presence => true,
                          :length => { :maximum => 4000 }
  validates :url, :length => { :maximum => 2000 }
  validates :category_id, :presence => true
  validates :user_id, :presence => true
end
