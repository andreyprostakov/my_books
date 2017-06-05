class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :name, :editions_count
end
