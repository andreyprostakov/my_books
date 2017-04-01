# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_authors_on_name  (name) UNIQUE
#

class Author < ActiveRecord::Base
  has_many :m2m_book_authors, inverse_of: :author
  has_many :books, through: :m2m_book_authors, inverse_of: :authors
  has_many :editions, through: :books, inverse_of: :authors
  has_many :categories,
    -> { group('edition_categories.id') },
    through: :editions

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order(:name) }
  scope :by_category_code, lambda { |code|
    joins(:categories).
      where(edition_categories: { code: code }).
      group('authors.id')
  }
end
