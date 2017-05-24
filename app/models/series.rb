# == Schema Information
#
# Table name: series
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  editions_count :integer          default(0), not null
#

class Series < ApplicationRecord
  has_many :editions
  has_many :authors, through: :editions
  has_many :publishers, through: :editions

  validates :title, presence: true

  scope :by_names, -> { order(:title) }
  scope :by_author, -> (name) { includes(:authors).where(authors: { name: name }) }
  scope :by_publisher, -> (name) { includes(:publishers).where(publishers: { name: name }) }
end
