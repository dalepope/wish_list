module UsersHelper

  def gravatar_for(user, options = { :size => 50 })
    options.merge!( { :secure => request.ssl? } )
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
