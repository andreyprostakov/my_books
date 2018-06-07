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
  CODES = [
    FICTION = :fiction,
    COMICS = :comics,
    ENCYCLIPEDIA = :encyclopedia,
    MEDIA = :media,
    NON_FICTION = :non_fiction
  ].freeze

  has_many :editions, foreign_key: :edition_category_id, inverse_of: :category

  validates :code, presence: true, uniqueness: true

  CODES.each do |code|
    define_singleton_method code do
      find_by(code: code)
    end
  end

  def title
    I18n.t(code, scope: 'categories')
  end

  def to_param
    code
  end
end
