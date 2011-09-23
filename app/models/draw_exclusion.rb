class DrawExclusion < ActiveRecord::Base
  attr_accessible :excluded_id
  
  belongs_to :excluder, :class_name => "User"
  belongs_to :excluded, :class_name => "User"
  
  validates :excluder_id, :presence => true
  validates :excluded_id, :presence => true
end
