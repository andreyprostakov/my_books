class EditionSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :authors,
    :cover_url,
    :category,
    :read

  def title
    object.title.presence ||
      object.books.map(&:title).join(', ')
  end

  def authors
    object.authors.map(&:name)
  end

  def category
    object.category.try(:code)
  end

  def cover_url
    object.cover.url(:thumb)
  end
end
