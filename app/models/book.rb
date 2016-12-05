# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  author     :string           not null
#  isbn       :string
#  cover_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  removed    :boolean          default(FALSE), not null
#  annotation :text
#

class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true

  scope :active, -> { where(removed: false) }
  scope :ordered_by_author, -> { order(:author) }
end
