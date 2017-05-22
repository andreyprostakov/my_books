class Series < ApplicationRecord
  has_many :editions

  validates :title, presence: true

  scope :by_names, -> { order(:title) }
end
