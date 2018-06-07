require 'rails_helper'

RSpec.describe Series do
  it { is_expected.to have_many :editions }
  it { is_expected.to have_many(:authors).through(:editions) }
  it { is_expected.to have_many(:publishers).through(:editions) }

  it { is_expected.to validate_presence_of(:title) }

  describe '.by_author' do
    let!(:edition_1) { create(:edition, series: create(:series)) }
    let!(:edition_2) { create(:edition, series: create(:series)) }
    subject { described_class.by_author(edition_1.authors.last.name) }

    it 'queries series by publisher' do
      is_expected.to be_present
      is_expected.to match_array(edition_1.series)
      is_expected.not_to match_array(edition_2.series)
    end
  end

  describe '.by_publisher' do
    let!(:edition_1) { create(:edition, series: create(:series)) }
    let!(:edition_2) { create(:edition, series: create(:series)) }
    subject { described_class.by_publisher(edition_1.publisher.name) }

    it 'queries series by publisher' do
      is_expected.to be_present
      is_expected.to match_array(edition_1.series)
      is_expected.not_to match_array(edition_2.series)
    end
  end

  describe '.in_category' do
    let!(:edition_1) do
      create(:edition, series: create(:series), category: create(:edition_category))
    end
    let!(:edition_2) do
      create(:edition, series: create(:series), category: create(:edition_category))
    end
    subject { described_class.in_category(edition_2.category.code) }

    it 'queries authors by category' do
      is_expected.to be_present
      is_expected.not_to match_array(edition_1.series)
      is_expected.to match_array(edition_2.series)
    end
  end
end
