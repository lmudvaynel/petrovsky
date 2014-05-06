aparts_positions = {
  [3, 1] => [428, 262],
  [3, 2] => [951, 262],
  [3, 4] => [1370, -226],
  [3, 5] => [1995, 262],
  [3, 6] => [1688, 575],
  [3, 7] => [1377, 575],
  [3, 8] => [1168, 575],
  [3, 9] => [749, 575],
  [3, 10] => [329, 575],
  [3, 13] => [103, 262],
  [6, 1] => [506, 65],
  [6, 2] => [976, 65],
  [6, 3] => [1354, 65],
  [6, 4] => [1543, 65],
  [6, 5] => [1886, 63],
  [6, 6] => [1567, 343],
  [6, 7] => [1174, 343],
  [6, 8] => [796, 345],
  [6, 9] => [415, 343],
  [6, 10] => [213, 61]
}
sold_out = false

Apartment.reset_column_information
aparts_positions.each do |number, position|
  path = "public/uploads/apartment/image"
  apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}.png")),
                                image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}-sold.png")),
                                dx: position.first,
                                dy: position.second,
                                number: number.second,
                                floor_number: number.first,
                                area: 10,
                                price: 10,
                                sold_out: sold_out
end
