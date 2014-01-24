class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :content, html: true

  scope :where_slug_is_not, ->(excluded_slugs) do
    excluded_slugs = [excluded_slugs] unless excluded_slugs.is_a? Array
    where slug: (all.map(&:slug) - excluded_slugs.map(&:to_s))
  end
end
