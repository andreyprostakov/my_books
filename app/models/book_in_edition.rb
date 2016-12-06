# == Schema Information
#
# Table name: book_in_editions
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  edition_id :integer          not null
#  title      :string
#  translator :string
#
# Indexes
#
#  index_book_in_editions_on_book_id     (book_id)
#  index_book_in_editions_on_edition_id  (edition_id)
#

class BookInEdition < ApplicationRecord
  belongs_to :book
  belongs_to :edition

  validates_presence_of :book, :edition
end
