class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :subpages, class_name: 'Page', foreign_key: :parent_id

  belongs_to :parent, class_name: 'Page'

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :content, html: true

  scope :for_menu, -> { where('parent_id IS NULL') }
  scope :where_slug_is_not, ->(excluded_slugs) do
    excluded_slugs = [excluded_slugs] unless excluded_slugs.is_a? Array
    where slug: (all.map(&:slug) - excluded_slugs.map(&:to_s))
  end
end
