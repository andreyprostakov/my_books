# == Schema Information
#
# Table name: edition_categories
#
#  id   :integer          not null, primary key
#  code :string           not null
#
# Indexes
#
#  index_edition_categories_on_code  (code) UNIQUE
#

class EditionCategory < ApplicationRecord
  has_many :editions, foreign_key: :edition_category_id, inverse_of: :category

  validates :code, presence: true, uniqueness: true

  def title
    I18n.t(code, scope: 'categories')
  end

  def to_param
    code
  end
end
