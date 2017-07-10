module UsersHelper

  def avatar_for(user, size: 80)
    return gravatar_for user, size: size
  end

  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://s.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    return image_tag(gravatar_url, alt: "#{user.name}'s Avatar", class: "gravatar", style: "width: #{size}px; height: #{size}px")
  end

  def gravatar_with_link_for(user, size: 80)
    link_to gravatar_for(user, size: size), user
  end

  def following_link_for(user)
    count = user.following.count
    link_to("#{count} following", following_user_path(user), id: "following")
  end

  def followers_link_for(user)
    count = user.followers.count
    link_to(pluralize(count, "follower"), followers_user_path(user), id: "followers")
  end

  def following_text_for(user)
    pluralize(user.following.count, "follower")
  end

  def followers_text_for(user)
    pluralize(user.followers.count, "follower")
  end

end
