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
  has_many :book_in_editions, inverse_of: :book, autosave: true
  has_many :editions, through: :book_in_editions, inverse_of: :books, autosave: true
  has_many :m2m_book_authors
  has_many :authors, through: :m2m_book_authors

  accepts_nested_attributes_for :editions, allow_destroy: true
  accepts_nested_attributes_for :authors

  validates :title, presence: true

  scope :by_titles, -> { order :title }
end
