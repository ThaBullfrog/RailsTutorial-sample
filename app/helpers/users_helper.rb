module UsersHelper

  def avatar_for(user, size: 80)
    return gravatar_for user, size: size
  end

  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://s.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    return image_tag(gravatar_url, alt: "#{user.name}'s Avatar", class: "gravatar", style: "width: 80px; height: 80px")
  end

end
