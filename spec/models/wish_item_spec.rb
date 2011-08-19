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

require 'spec_helper'

describe WishItem do
  pending "add some examples to (or delete) #{__FILE__}"
end
