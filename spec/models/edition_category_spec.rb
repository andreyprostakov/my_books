require 'rails_helper'

RSpec.describe EditionCategory do
  it { is_expected.to have_many :editions }

  describe 'validation' do
    subject { build :edition_category }

    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :code }
  end
end
