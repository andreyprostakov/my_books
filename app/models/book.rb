# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  author     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Book < ApplicationRecord
  has_many :book_in_editions
  has_many :editions, through: :book_in_editions

  accepts_nested_attributes_for :editions, allow_destroy: true

  validates :title, presence: true
  validates :author, presence: true

  scope :ordered_by_author, -> { order(:author) }
end
