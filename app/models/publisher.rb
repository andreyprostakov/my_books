# == Schema Information
#
# Table name: publishers
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Publisher < ApplicationRecord
  has_many :editions
  has_many :categories,
    -> { group('edition_categories.id') },
    through: :editions

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order :name }
  scope :by_category_code, lambda { |code|
    joins(:categories).
      where(edition_categories: { code: code }).
      group('publishers.id')
  }
end
