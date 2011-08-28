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

  belongs_to :user
  belongs_to :category, :class_name => "WishCategory", :foreign_key => "category_id"
  
  default_scope :order => 'wish_items.created_at DESC'

  url_regex = /\A\z|\Ahttps?:\/\/[^<^>^"^']+\z/i
  
  validates :description, :presence => true,
                          :length => { :maximum => 4000 }
  validates :url, :length => { :maximum => 2000 }, 
                  :format => { :with => url_regex }
  validates :category_id, :presence => true
  validates :user_id, :presence => true
end
