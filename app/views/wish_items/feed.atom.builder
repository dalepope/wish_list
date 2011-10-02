atom_feed :language => 'en-US' do |feed|
  feed.title @title
  feed.updated @updated

  @wish_items.each do |item|
    next if item.updated_at.blank?

    feed.entry( item ) do |entry|
      entry.url wish_item_url(item)
      entry.title (item.user.name + " wants " + item.description)[0..39]
      content = item.user.name + " added "
      if item.url.blank?
        content += item.description
      else
        content += link_to(item.description, item.url)
      end
      entry.content content + " to his/her wish list.", :type => 'html'

      # the strftime is needed to work with Google Reader.
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) 

      entry.author do |author|
        author.name item.user.name
      end
    end
  end
end