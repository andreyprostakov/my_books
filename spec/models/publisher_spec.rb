require 'rails_helper'

RSpec.describe Publisher do
  it { is_expected.to have_many :editions }
  it { is_expected.to have_many(:authors).through(:editions) }
  it { is_expected.to have_many(:series).through(:editions) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
end
