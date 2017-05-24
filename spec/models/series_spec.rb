require 'rails_helper'

RSpec.describe Series do
  it { is_expected.to have_many :editions }
  it { is_expected.to have_many(:authors).through(:editions) }
  it { is_expected.to have_many(:publishers).through(:editions) }

  it { is_expected.to validate_presence_of(:title) }
end