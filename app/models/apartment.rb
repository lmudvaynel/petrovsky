class Apartment < ActiveRecord::Base
  validates :image, :dx, :dy, :number, :floor_number, presence: true

  mount_uploader :image, ApartmentImageUploader
end
