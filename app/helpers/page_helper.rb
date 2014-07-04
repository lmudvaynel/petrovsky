module PageHelper
  def render_page
    page = render "/pages/shared/#{@page.slug.gsub('-', '_')}"
    if page
      page + init_shared_page_js
    else
      @page.try(:content)
    end
  rescue
    @page.try(:content)
  end

  def init_shared_page_js
    return unless @page
    js_fullname = "#{controller_name}/shared/#{@page.slug.gsub('-', '_')}"
    fullname_js = "#{js_fullname}.js"
    fullname_js_coffee = "#{js_fullname}.js.coffee"
    if File.exist?(Rails.root.join('app', 'assets', 'javascripts', fullname_js)) ||
       File.exist?(Rails.root.join('app', 'assets', 'javascripts', fullname_js_coffee))
      javascript_include_tag js_fullname
    end
  end 
end
