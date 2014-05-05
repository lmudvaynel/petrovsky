=begin

floors_count = 6
aparts_positions = {
  1 => [123, 172],
  2 => [609, 172]
}
sold_out = false

Apartment.reset_column_information
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
