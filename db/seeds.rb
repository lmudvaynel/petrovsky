puts "Seeding..."
seeds= {
  'pages.rb'=> 1,
  'messages.rb'=> 0,
  'apartments'=> 0
}

seeds.each do |file,flag|
  if flag==1
    print "-> #{file} ... "
    load "db/seeds/#{file}" 
    puts "ok"
  end
end

puts "Done"
