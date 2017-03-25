class EditionDetailsSerializer < EditionSerializer
  attributes :id,
    :title,
    :authors,
    :cover_url,
    :category,
    :publisher,
    :publication_year,
    :pages_count,
    :isbn,
    :annotation
    :read

  def cover_url
    object.cover.url
  end

  def isbn
    object.isbn unless object.isbn == Edition::EMPTY_ISBN
  end

  def publisher
    object.publisher.try(:name)
  end
end
