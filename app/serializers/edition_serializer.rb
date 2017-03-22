class EditionSerializer < ActiveModel::Serializer
  attributes :id,
  	:title,
  	:authors,
  	:cover_url,
  	:category,
  	:read

  def title
    object.title.presence ||
      object.books.map { |b| "\"#{b.title}\"" }.join(', ')
  end

  def authors
  	object.authors.map(&:name)
  end

  def category
  	object.category.try(:code)
  end
end
