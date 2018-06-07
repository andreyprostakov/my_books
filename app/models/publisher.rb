# == Schema Information
#
# Table name: publishers
#
#  id             :integer          not null, primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  editions_count :integer          default(0), not null
#

class Publisher < ApplicationRecord
  has_many :editions
  has_many :authors, through: :editions
  has_many :series, through: :editions
  has_many :categories, through: :editions

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order :name }
  scope :for_author, -> (name) { includes(:authors).where(authors: { name: name }) }
  scope :of_series, -> (title) { includes(:series).where(series: { title: title }) }
  scope :in_category, -> (category_code) do
    includes(:categories).where(edition_categories: { code: category_code })
  end
end
