floors_count = 6
aparts_positions = {
  1 => [0, 0],
  2 => [300, 0],
  3 => [0, 300],
  4 => [300, 300]
}

Apartment.reset_column_information
(1..floors_count).each do |floor_number|
  aparts_positions.each do |number, position|
    path = "public/uploads/apartment/image"
    apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{floor_number}-#{number}.png")),
                                  dx: position.first,
                                  dy: position.second,
                                  number: number,
                                  floor_number: floor_number
  end
end
