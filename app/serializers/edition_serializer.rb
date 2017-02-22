class EditionSerializer < ActiveModel::Serializer
  attributes :id, :title, :cover_url, :read

  def title
    object.full_title
  end

end
