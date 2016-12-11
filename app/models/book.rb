# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author     :string           not null
#

class Book < ApplicationRecord
  has_many :book_in_editions
  has_many :editions, through: :book_in_editions
  has_many :m2m_book_authors
  has_many :authors, through: :m2m_book_authors

  accepts_nested_attributes_for :editions, allow_destroy: true

  validates :title, presence: true
  validates :authors, presence: true

  scope :ordered_by_author, -> { all }

  def author
    authors.first
  end
end
