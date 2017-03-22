class EditionSerializer < ActiveModel::Serializer
  attributes :id,
  	:title,
  	:authors,
  	:cover_url,
  	:read

  def authors
  	object.authors.map(&:name)
  end
end
