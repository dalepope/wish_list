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
  
  def get_owned_links(owned)
    links = ""
    owned.each_index do |i|
      links += ", " if i > 0
      links += link_to owned[i].name, sessions_switch_path(:id => owned[i].id)
    end
    return links
  end
end
