class Apartment < ActiveRecord::Base
  validates :image, :dx, :dy, :number, :floor_number, presence: true

  mount_uploader :image, ApartmentImageUploader
  mount_uploader :image_sold, ApartmentImageUploader
  def to_hash
    {
      id: id,
      image: image.file.filename,
      image_sold: image.file.filename,
      size: image.get_geometry,
      dx: dx,
      dy: dy,
      number: number,
      floor_number: floor_number,
      sold_out: sold_out,
      price: price,
      area: area
    }
  end
end
