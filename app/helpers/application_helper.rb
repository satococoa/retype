module ApplicationHelper
  def page_slug
    controller.class.to_s.underscore.
      gsub(/\//, '-').
      gsub(/_controller/, '_') + action_name
  end

  def browser_hack
    if browser.ie?
      'is-ie is-ie' + browser.version
    else
      'is-' + browser.name.downcase
    end
  end

end
