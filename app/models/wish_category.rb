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
  NONE = "none"

  attr_accessible :name

  has_many :wish_items
  
  validates :name, :presence => true,
                   :length   => { :maximum => 20 },
                   :uniqueness => { :case_sensitive => false }

  before_validation :ensure_name_has_value
  
  def none?
    name == NONE
  end
  
  private
  
    def ensure_name_has_value
      self.name = NONE if name.blank?
    end
end
