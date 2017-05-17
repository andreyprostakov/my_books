require 'rails_helper'

RSpec.describe EditionsBatchFormHandler do
  let(:handler) { described_class.new(params) }
  let(:params) { double :params }
  let(:batch_params) { double :batch_params }
  let(:previous_category) { create :edition_category }
  let(:new_category) { create :edition_category }
  let(:new_publisher) { create :publisher }
  let(:raw_params) do
    {
      read: true,
      category: { code: new_category.code },
      publisher: { name: new_publisher.name }
    }
  end

  before do
    allow(params).to receive(:require).
      with(:editions_batch).
      and_return(batch_params)
    allow(batch_params).to receive(:permit).
      with(*described_class::BATCH_PARAMS).
      and_return(raw_params)
  end

  describe '#update_editions' do
    let!(:editions) do
      create_list(:edition, 2, read: false, category: previous_category)
    end

    it 'updates editions with given params', :aggregate_failures do
      handler.update_editions(editions)
      editions.each(&:reload)
      editions.each do |edition|
        expect(edition).to be_read
        expect(edition.category).to eq new_category
        expect(edition.publisher).to eq new_publisher
      end
    end
  end
end
