# == Schema Information
#
# Table name: editions
#
#  id                  :integer          not null, primary key
#  isbn                :string
#  title               :string
#  annotation          :text
#  editor              :string
#  pages_count         :integer
#  language_code       :string
#  edition_category_id :integer
#  publisher_id        :integer
#  publication_year    :integer          default(1999)
#  cover               :string
#  created_at          :datetime
#  updated_at          :datetime
#  read                :boolean          default(FALSE)
#  series_id           :integer
#
# Indexes
#
#  index_editions_on_edition_category_id  (edition_category_id)
#  index_editions_on_publisher_id         (publisher_id)
#  index_editions_on_series_id            (series_id)
#

class Edition < ApplicationRecord
  belongs_to :category,
    class_name: EditionCategory,
    foreign_key: :edition_category_id
  belongs_to :publisher, optional: true, counter_cache: true
  belongs_to :series, optional: true, counter_cache: true

  has_many :books, inverse_of: :edition, dependent: :destroy
  has_many :authors, -> { group('authors.id') }, through: :books, inverse_of: :editions

  scope :with_category_code, lambda { |code|
    joins(:category).where(edition_categories: { code: code })
  }
  scope :with_author, lambda { |author|
    if author.is_a? Author
      joins(:authors).where('authors.id = ?', author)
    else
      joins(:authors).where('authors.name = ?', author.to_s)
    end
  }
  scope :with_publisher, lambda { |publisher|
    if publisher.is_a? Publisher
      joins(:publisher).where('publishers.id = ?', publisher)
    else
      joins(:publisher).where('publishers.name = ?', publisher.to_s)
    end
  }
  scope :from_series, lambda { |series|
    if series.is_a? Series
      joins(:series).where('series.id = ?', series)
    else
      joins(:series).where('series.title = ?', series.to_s)
    end
  }
  scope :by_book_titles, lambda {
    includes(:books).order('books.title').group('editions.id')
  }
  scope :old_first, -> { order(:publication_year) }
  scope :new_first, -> { order(publication_year: :desc) }
  scope :by_updated_at, -> { order(updated_at: :desc) }
  scope :by_author, lambda {
    includes(:authors).
      order('authors.name').
      group('editions.id')
  }

  accepts_nested_attributes_for :books, allow_destroy: true
  accepts_nested_attributes_for :publisher

  validates_presence_of :books

  mount_uploader :cover, ::BookCoverUploader

  after_create :update_authors_editions_count
  after_destroy :update_authors_editions_count

  private

  def update_authors_editions_count
    authors.each(&:update_editions_count)
  end
end
