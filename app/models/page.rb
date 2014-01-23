class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :content, html: true
end
