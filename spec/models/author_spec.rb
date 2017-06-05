require 'rails_helper'

RSpec.describe Author, type: :model do
  it { is_expected.to have_many :books }
  it { is_expected.to have_many :editions }
  it { is_expected.to have_many(:publishers).through(:editions) }
  it { is_expected.to have_many(:series).through(:editions) }

  describe 'validation' do
    it { is_expected.to validate_presence_of :name }
  end

  describe '.for_publisher' do
    let!(:editions) { create_list(:edition, 2) }
    subject { described_class.for_publisher(editions.last.publisher.name) }

    it 'queries authors by publisher' do
      is_expected.to be_present
      is_expected.to match_array(editions.last.authors)
      is_expected.not_to match_array(editions.first.authors)
    end
  end

  describe '.of_series' do
    let!(:edition_1) { create(:edition, series: create(:series)) }
    let!(:edition_2) { create(:edition, series: create(:series)) }
    subject { described_class.of_series(edition_1.series.title) }

    it 'queries authors by series' do
      is_expected.to be_present
      is_expected.to match_array(edition_1.authors)
      is_expected.not_to match_array(edition_2.authors)
    end
  end

  describe '.in_category' do
    let!(:edition_1) { create(:edition, category: create(:edition_category)) }
    let!(:edition_2) { create(:edition, category: create(:edition_category)) }
    subject { described_class.in_category(edition_2.category.code) }

    it 'queries authors by category' do
      is_expected.to be_present
      is_expected.not_to match_array(edition_1.authors)
      is_expected.to match_array(edition_2.authors)
    end
  end
end
