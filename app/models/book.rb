# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  edition_id :integer          not null
#
# Indexes
#
#  index_books_on_edition_id            (edition_id)
#  index_books_on_edition_id_and_title  (edition_id,title) UNIQUE
#

class Book < ApplicationRecord
  belongs_to :edition, inverse_of: :books
  has_many :m2m_book_authors, inverse_of: :book, dependent: :destroy
  has_many :authors, through: :m2m_book_authors, inverse_of: :books

  accepts_nested_attributes_for :authors

  validates :title, presence: true
  validates :edition, presence: true
  validates_uniqueness_of :title, scope: [:edition_id]

  scope :by_titles, -> { order :title }
end
