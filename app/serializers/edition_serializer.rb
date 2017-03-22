class EditionSerializer < ActiveModel::Serializer
  attributes :id,
  	:title,
  	:authors,
  	:cover_url,
  	:read

  def title
    object.title.presence ||
      object.books.map { |b| "\"#{b.title}\"" }.join(', ')
  end

  def authors
  	object.authors.map(&:name)
  end
end
