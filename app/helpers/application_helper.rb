module ApplicationHelper

  def title
    pre_title = "Wish Lists"
    if @title.nil?
      pre_title
    else
      "#{pre_title} - #{@title}"
    end
  end
end
