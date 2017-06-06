class EditionSerializer < ActiveModel::Serializer
  attributes :id,
    :title,
    :cover_url,
    :category,
    :annotation,
    :read

  has_many :authors
  has_one :series

  def title
    object.title.presence ||
      object.books.map(&:title).join(', ')
  end

  def cover_url
    object.cover.url(:thumb)
  end
end
