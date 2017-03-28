class EditionDetailsSerializer < EditionSerializer
  attributes :id,
    :title,
    :books,
    :cover_url,
    :publication_year,
    :pages_count,
    :isbn,
    :annotation
    :read

  has_many :authors
  has_one :category
  has_one :publisher

  def books
    object.books.map { |b| BookSerializer.new(b) }
  end
end
