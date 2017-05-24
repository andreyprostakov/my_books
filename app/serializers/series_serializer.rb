class SeriesSerializer < ActiveModel::Serializer
  attributes :id, :title, :editions_count
end
