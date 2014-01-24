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
    Page.create!(name: subpage_name, title: parent_page_name, content: '')
  end
end
