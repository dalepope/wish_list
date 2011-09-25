module ApplicationHelper

  def title
    pre_title = "Wish Lists"
    if @title.nil?
      pre_title
    else
      "#{pre_title} - #{@title}"
    end
  end
  
  def webmaster_contact
    mail_to "dale@dalepope.name", "Dale"
  end
end
