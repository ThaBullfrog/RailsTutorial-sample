module ApplicationHelper
  def full_title(page_title='')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      return base_title
    else
      return page_title + " | " + base_title
    end
  end

  def show_flashes
    returns = Array.new
    flash.each do |message_type, message|
      returns.push(("<div class=\"alert alert-" + message_type + "\">" + message + "</div>"))
    end
    return returns.join.html_safe
  end

  def write_post_collapse(local_assigns)
    render 'shared/write_post_collapse', write_post_expanded: local_assigns.fetch(:write_post_expanded, false)
  end

  def pluralize_without_number(count, string)
    array = pluralize(count, string).split(" ")
    array.delete_at(0)
    return array.join(" ")
  end
end
