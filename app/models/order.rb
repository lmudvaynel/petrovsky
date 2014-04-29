class Order < ActiveRecord::Base
  validates :name, presence: true 
  validates :phone, presence: true 
  validates :content, presence: true 
end
