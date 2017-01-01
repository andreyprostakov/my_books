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

  validates :name, presence: true, uniqueness: true

  scope :by_names, -> { order :name }
end
