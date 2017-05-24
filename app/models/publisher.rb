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
  has_many :authors, through: :editions
  has_many :series, through: :editions

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order :name }
  scope :for_author, -> (name) { includes(:authors).where(authors: { name: name}) }
  scope :of_series, -> (title) { includes(:series).where(series: { title: title }) }
end
