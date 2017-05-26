# == Schema Information
#
# Table name: m2m_book_authors
#
#  id        :integer          not null, primary key
#  author_id :integer          not null
#  book_id   :integer          not null
#
# Indexes
#
#  index_m2m_book_authors_on_author_id              (author_id)
#  index_m2m_book_authors_on_author_id_and_book_id  (author_id,book_id) UNIQUE
#  index_m2m_book_authors_on_book_id                (book_id)
#

class M2mBookAuthor < ActiveRecord::Base
  belongs_to :author, inverse_of: :m2m_book_authors
  belongs_to :book, inverse_of: :m2m_book_authors

  validates_presence_of :author
  validates :book, presence: true, uniqueness: { scope: :author_id }

  after_create :update_author_editions_count
  after_destroy :update_author_editions_count

  private

  def update_author_editions_count
    binding.pry
    author.update_editions_count
  end
end
