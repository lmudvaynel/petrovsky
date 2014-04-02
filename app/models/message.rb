class Message < ActiveRecord::Base
  scope :showed, -> { where(showed: true) }
end
