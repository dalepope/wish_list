class DrawnNameHistory < ActiveRecord::Base
  attr_protected :year, :giver_id, :receiver_id
  
  belongs_to :giver, :class_name => "User"
  belongs_to :receiver, :class_name => "User"

  validates :year, :presence => true
  validates :giver_id, :presence => true
  validates :receiver_id, :presence => true
end
