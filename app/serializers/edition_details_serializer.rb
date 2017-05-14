class EditionDetailsSerializer < EditionSerializer
  attributes :id,
    :title,
    :books,
    :cover_url,
    :cover_original_url,
    :publication_year,
    :pages_count,
    :isbn,
    :annotation,
    :read

  has_many :authors
  has_one :category
  has_one :publisher

  def title
    object.title
  end

  def books
    object.books.map { |b| BookSerializer.new(b) }
  end

  def cover_url
    object.cover.url(:detailed)
  end

  def cover_original_url
    object.cover.url
  end
end
