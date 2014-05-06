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
  [3, 13] => [103, 262]
}
sold_out = false

Apartment.reset_column_information
aparts_positions.each do |number, position|
  path = "public/uploads/apartment/image"
  apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}.png")),
                                image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}-sold.png")),
                                dx: position.first,
                                dy: position.second,
                                number: number,
                                floor_number: floor_number,
                                area: 10,
                                price: 10,
                                sold_out: sold_out
end
