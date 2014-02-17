floors_count = 6
aparts_positions = {
  1 => [200, 150],
  2 => [600, 150]
}
sold_out = false

Apartment.reset_column_information
(1..floors_count).each do |floor_number|
  aparts_positions.each do |number, position|
    path = "public/uploads/apartment/image"
    apartment = Apartment.create! image: open(File.join(Rails.root, path, "#{floor_number}-#{number}.png")),
                                  dx: position.first,
                                  dy: position.second,
                                  number: number,
                                  floor_number: floor_number,
                                  sold_out: sold_out
    sold_out = !sold_out
  end
  sold_out = !sold_out
end
