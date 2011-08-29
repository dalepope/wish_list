module WishItemsHelper

  def make_wish(category, description, url)
    wish_text = ""
    unless category.empty?
      wish_text = category + ": "
    end
    wish_text += description
    
    if url.empty?
      wrap(wish_text)
    else
      link_to(wrap(wish_text), url)
    end
  end

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end
