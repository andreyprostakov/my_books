require 'rails_helper'

RSpec.describe Edition, type: :model do
  it { is_expected.to belong_to(:category).class_name(EditionCategory) }
  it { is_expected.to belong_to(:publisher) }
  it { is_expected.to have_many :book_in_editions }
  it { is_expected.to have_many :books }
  it { is_expected.to have_many :authors }

  describe 'validation' do
    it { is_expected.to validate_presence_of :isbn }
    it { is_expected.to validate_presence_of :books }
  end
end
