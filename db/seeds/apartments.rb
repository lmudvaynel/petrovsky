<<<<<<< HEAD
floor_number = 3
=======
=begin

floors_count = 6
>>>>>>> 04f0f81507b51da3fb625229cb596d0d76e8fb7a
aparts_positions = {
  1 => [428, 262],
  2 => [951, 262],
  4 => [1370, -226],
  5 => [1995, 262],
  6 => [1688, 575],
  7 => [1377, 575],
  8 => [1168, 575],
  9 => [749, 575],
  10 => [329, 575],
  13 => [103, 262]
}
sold_out = false

Apartment.reset_column_information
<<<<<<< HEAD
aparts_positions.each do |number, position|
  path = "public/uploads/apartment/image"
  apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{floor_number}-#{number}.png")),
                                image: open(File.join(Rails.root, path, "#{floor_number}-#{number}-sold.png")),
                                dx: position.first,
                                dy: position.second,
                                number: number,
                                floor_number: floor_number,
                                area: 10,
                                price: 10,
                                sold_out: sold_out
end
=======
(1..floors_count).each do |floor_number|
  aparts_positions.each do |number, position|
    path = "public/uploads/apartment/image"
    apartment = Apartment.create! dx: position.first,
                                  dy: position.second,
                                  number: number,
                                  floor_number: floor_number,
                                  sold_out: sold_out,
                                  image: open(File.join(Rails.root, path, "#{floor_number}-#{number}.png")),
                                  price: rand(1..9) * 100_000,
                                  area: rand(1..9) * 10
    sold_out = !sold_out
  end
  sold_out = !sold_out
end

=end
>>>>>>> 04f0f81507b51da3fb625229cb596d0d76e8fb7a
