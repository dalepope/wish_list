class Ownership < ActiveRecord::Base
  attr_accessible :owned_id
  
  belongs_to :owner, :class_name => "User"
  belongs_to :owned, :class_name => "User"
  
  validates :owner_id, :presence => true
  validates :owned_id, :presence => true
end
