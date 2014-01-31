module PageHelper
  def render_page
    render "/pages/shared/#{@page.slug.gsub('-', '_')}"
    init_shared_page_js
  rescue
    @page.try(:content)
  end

  def init_shared_page_js
    return unless @page
    js_fullname = "#{controller_name}/shared/#{@page.slug.gsub('-', '_')}"
    if File.exist? Rails.root.join('app', 'assets', 'javascripts', "#{js_fullname}.js.coffee")
      javascript_include_tag js_fullname
    end
  end
end
