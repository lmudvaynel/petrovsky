aparts_positions = {
#[этаж, квартира] => [dx, dy, площадь, стоимость, проданы?]
  [3, 1] => [428, 562, 74.2, 200000, true],
  [3, 2] => [951, 562, 38.0, 200000, true],
  [3, 4] => [1370, 74, 145.6, 684902, false],
  [3, 5] => [1995, 562, 97.8, 200000, true],
  [3, 6] => [1688, 875, 62.1, 200000, true],
  [3, 7] => [1377, 875, 57.7, 200000, true],
  [3, 8] => [1168, 875, 38.7, 200000, true],
  [3, 9] => [749, 875, 76.5, 200000, true],
  [3, 10] => [329, 875, 83.3, 200000, true],
  [3, 13] => [103, 562, 98.2, 200000, true],
  [6, 1] => [506, 365, 74.2, 505821, false],
  [6, 2] => [976, 365, 77.3, 500000, true],
  [6, 3] => [1354, 365, 38.3, 500000, true],
  [6, 4] => [1543, 365, 56.8, 388058, false],
  [6, 5] => [1886, 363, 140.3, 954040, false],
  [6, 6] => [1567, 643, 115.8, 500000, true],
  [6, 7] => [1174, 643, 170.3, 1141010, false],
  [6, 8] => [796, 645, 148.1, 1007080, false],
  [6, 9] => [415, 643, 136.3, 500000, true],
  [6, 10] => [213, 361, 148.9, 1012520, false]
}

Apartment.reset_column_information
aparts_positions.each do |number, position|
  path = "public/uploads/apartment/image"
  apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}.png")),
                                image: open(File.join(Rails.root, path, "#{number.first}-#{number.second}-sold.png")),
                                dx: position[0],
                                dy: position[1],
                                number: number.second,
                                floor_number: number.first,
                                area: position[2],
                                price: position[3],
                                sold_out: position[4]
end
