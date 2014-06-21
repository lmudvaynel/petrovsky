module ApplicationHelper
  def set_content_for(section, content)
    content_for section do
      content
    end if content
  end

  def javascript_controller_exist?
    file_name = "#{controller_name}.js.coffee"
    File.exist? Rails.root.join('app', 'assets', 'javascripts', file_name)
  end

  def javascript_require_controller
    return unless javascript_controller_exist?
    javascript_include_tag "#{controller_name}"
  end

  def javascript_action_exist?
    file_name = "#{action_name}.js.coffee"
    File.exist? Rails.root.join('app', 'assets', 'javascripts', controller_name, file_name)
  end
  def javascript_require_action
    return unless javascript_action_exist?
    javascript_include_tag "#{controller_name}/#{action_name}"
  end

  def javascript_init_action
    return unless javascript_action_exist?
    raw <<-JAVASCRIPT
      <script>
        $.app.#{controller_name}.#{action_name}.init();
      </script>
    JAVASCRIPT
  end
end
