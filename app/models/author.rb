# == Schema Information
#
# Table name: authors
#
#  id   :integer          not null, primary key
#  name :string           not null
#
# Indexes
#
#  index_authors_on_name  (name) UNIQUE
#

class Author < ActiveRecord::Base
  has_many :m2m_book_authors
  has_many :books, through: :m2m_book_authors
  has_many :editions, through: :books

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order(:name) }
end
