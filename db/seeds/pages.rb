# encoding: utf-8

pages_names = [
  'index',
  'characters'
]

Page.reset_column_information
pages_names.each do |page_slug|
  parent_page = Page.create! slug: page_slug, name: page_name, title: page_name, content: ''
end












# По всему сайту ужаснейший говнокод, но мне уже пофигу (:
=begin
pages_names = {
  'Home' => [],
  'Best' => ['Place', 'Service', 'Engineering', 'Design'],
  'Aparts' => ['Gallery', 'Floor Plans']
}
Page.reset_column_information
pages_names.each do |parent_page_name, subpages_names|
  parent_page = Page.create!(name: parent_page_name,
                             title: parent_page_name,
                             content: '')
  parent_page.subpages << subpages_names.map do |subpage_name|
    Page.create!(name: subpage_name, title: subpage_name, content: '')
  end
end
=end
