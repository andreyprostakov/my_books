# == Schema Information
#
# Table name: series
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Series < ApplicationRecord
  has_many :editions

  validates :title, presence: true

  scope :by_names, -> { order(:title) }
end
