class DrawnName < ActiveRecord::Base
  attr_protected :giver_id, :receiver_id
  
  belongs_to :giver, :class_name => "User"
  belongs_to :receiver, :class_name => "User"
  
  validates :giver_id, :presence => true
  validates :receiver_id, :presence => true
end
