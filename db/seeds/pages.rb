page_names = ['Index1', 'BEST', 'Place', 'Service1', 'Engineering',
              'Design1', 'APARTS', 'Gallery', 'Floor Plans']
#Page.reset_column_information
page_names.each do |page_name|
  page = FactoryGirl.create(:page, name: page_name)
  puts page
end
