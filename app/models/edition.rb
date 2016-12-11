# == Schema Information
#
# Table name: editions
#
#  id            :integer          not null, primary key
#  isbn          :string           not null
#  title         :string
#  annotation    :text
#  cover_url     :string
#  editor        :string
#  pages_count   :integer
#  language_code :string
#

class Edition < ApplicationRecord
  has_many :book_in_editions
  has_many :books, through: :book_in_editions

  accepts_nested_attributes_for :books, allow_destroy: true

  validates_presence_of :isbn, :books

  def build_book(parameters)
    byebug
  end

  def build_books(parameters)
    byebug
  end
end
