# == Schema Information
#
# Table name: wish_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WishCategory < ActiveRecord::Base
  attr_accessible :name

  has_many :wish_items
  
  validates :name, :presence => true,
                   :length   => { :maximum => 20 },
                   :uniqueness => { :case_sensitive => false }
end
