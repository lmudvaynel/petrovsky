aparts_positions = {
  [1, 1] => [428, 262],
  [1, 2] => [951, 262],
  [1, 4] => [1370, -226],
  [1, 5] => [1995, 262],
  [1, 6] => [1688, 575],
  [1, 7] => [1377, 575],
  [1, 8] => [1168, 575],
  [1, 9] => [749, 575],
  [1, 10] => [329, 575],
  [1, 13] => [103, 262]
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
