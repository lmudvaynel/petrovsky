module PageHelper
  def render_page
    render "/pages/shared/#{@page.slug.gsub('-', '_')}"
  rescue
    @page.try(:content)
  end
end
