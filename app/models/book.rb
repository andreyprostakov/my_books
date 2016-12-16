# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
  has_many :book_in_editions
  has_many :editions, through: :book_in_editions
  has_many :m2m_book_authors
  has_many :authors, through: :m2m_book_authors

  accepts_nested_attributes_for :editions, allow_destroy: true

  validates :title, presence: true

  def author_names
    authors.map(&:name)
  end

  def author_names=(names)
    names = names.select(&:present?)
    existing_authors = Author.where(name: names)
    new_author_names = names - existing_authors.map(&:name)
    new_authors = new_author_names.map { |name| Author.create!(name: name) }
    self.authors = existing_authors + new_authors
  end
end
