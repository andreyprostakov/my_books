class EditionSerializer < ActiveModel::Serializer
  attributes :id, :title, :cover_url, :edition_category, :read

  def edition_category
  	object.category.code
  end
end
