aparts_positions = {
#[этаж, квартира] => [dx, dy, площадь, стоимость, проданы?]
  [2, 1] => [427, 328, 66.7, 430215, false],
  [2, 2] => [951, 328, 76.5, 200000, true],
  [2, 3] => [1370, 328, 38.3, 266185, true],
  [2, 4] => [1580, 328, 55.5, 200000, true],
  [2, 5] => [1998, 328, 99.4, 594994, true],
  [2, 6] => [1690, 641, 62.2, 386200, false],
  [2, 7] => [1378, 641, 57.7, 401707, true],
  [2, 8] => [1168, 641, 38.7, 200000, true],
  [2, 9] => [748, 641, 76.5, 454946, false],
  [2, 10] => [326, 641, 83.3, 495385, false],
  [2, 11] => [103, 328, 98.2, 629920, true],
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
  [4, 1] => [427, 328, 74.2, 486158, false],
  [4, 2] => [951, 328, 77.3, 200000, true],
  [4, 3] => [1370, 328, 38.3, 266185, true],
  [4, 4] => [1580, 328, 56.8, 200000, true],
  [4, 5] => [1998, 328, 99.1, 594994, true],
  [4, 6] => [1690, 641, 62.1, 200000, true],
  [4, 7] => [1378, 641, 57.7, 401707, true],
  [4, 8] => [1168, 641, 38.7, 200000, true],
  [4, 9] => [748, 641, 76.5, 509796, true],
  [4, 10] => [326, 641, 83.3, 200000, true],
  [4, 11] => [103, 328, 97.3, 629920, true],
  [5, 1] => [427, 328, 74.2, 508047, false],
  [5, 2] => [951, 328, 77.3, 200000, true],
  [5, 3] => [1370, 328, 38.3, 266185, false],
  [5, 4] => [1580, 328, 56.8, 200000, true],
  [5, 5] => [1998, 328, 98.2, 594994, false],
  [5, 6] => [1690, 641, 62.1, 200000, true],
  [5, 7] => [1378, 641, 57.7, 401707, false],
  [5, 8] => [1168, 641, 38.7, 200000, true],
  [5, 9] => [748, 641, 76.5, 509796, false],
  [5, 10] => [326, 641, 83.3, 200000, true],
  [5, 11] => [103, 328, 97.3, 629920, false],
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
