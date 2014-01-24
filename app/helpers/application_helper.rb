module ApplicationHelper
  def set_content_for(section, content)
    content_for section do
      content
    end if content
  end
end
