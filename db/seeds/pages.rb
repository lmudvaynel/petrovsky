page_names = ['Main', 'Best', 'Aparts']
Page.reset_column_information
page_names.each do |page_name|
  page = FactoryGirl.create(:page, name: page_name)
  puts page
end
