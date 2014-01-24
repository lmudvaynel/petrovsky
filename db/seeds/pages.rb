pages_names = {
  'Home' => [],
  'Best' => ['Place', 'Service', 'Engineering', 'Design'],
  'Aparts' => ['Gallery', 'Floor Plans']
}
Page.reset_column_information
pages_names.each do |parent_page_name, subpages_names|
  parent_page = FactoryGirl.create(:page, name: parent_page_name)
  parent_page.subpages << subpages_names.map do |subpage_name|
    FactoryGirl.create(:page, name: subpage_name)
  end
end
