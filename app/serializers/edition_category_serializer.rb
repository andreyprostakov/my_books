class EditionCategorySerializer < ActiveModel::Serializer
  attributes :id, :code, :name

  def name
    I18n.t(object.code, scope: 'categories')
  end
end
