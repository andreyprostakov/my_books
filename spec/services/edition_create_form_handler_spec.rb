require 'rails_helper'

RSpec.describe EditionCreateFormHandler do
  let(:handler) { described_class.new(params) }

  describe '#create_edition' do
    subject { handler.create_edition }

    let(:params) { double :params }
    let(:edition_params) { double :edition_params }
    let(:raw_params) do
      {
        books: [
          {
            title: 'book title 1',
            authors: ['author A', 'author B']
          },
          {
            title: 'book title 2',
            authors: ['author B']
          }
        ],
        title: 'some edition title',
        annotation: 'some annotation',
        isbn: 'X-X-X',
        category: 'comics',
        publisher: 'some publisher',
        publication_year: 1999,
        pages_count: 10_000
      }
    end
    let!(:category) { create :edition_category, code: 'comics' }

    before do
      allow(params).to receive(:require).
        with(:edition).
        and_return(edition_params)
      allow(edition_params).to receive(:permit).
        with(*described_class::EDITION_PARAMS).
        and_return(raw_params)
    end

    it 'creates an Edition with valid data' do
      expect { subject }.
        to change { Edition.count }.by(1).
        and change { Author.count }.by(2).
        and change { Publisher.count }.by(1)
      edition = subject

      expect(edition).to be_a Edition
      aggregate_failures do
        expect(edition).to be_persisted
        expect(edition.title).to eq 'some edition title'
        expect(edition.annotation).to eq 'some annotation'
        expect(edition.isbn).to eq 'X-X-X'
        expect(edition.publication_year).to eq 1999
        expect(edition.pages_count).to eq 10_000
      end

      expect(edition.books.size).to eq 2
      expect(edition.books[0]).to be_persisted
      expect(edition.books[0].title).to eq 'book title 1'
      expect(edition.books[0].authors.size).to eq 2
      expect(edition.books[0].authors[0].name).to eq 'author A'
      expect(edition.books[0].authors[1].name).to eq 'author B'

      expect(edition.books[1]).to be_persisted
      expect(edition.books[1].title).to eq 'book title 2'
      expect(edition.books[1].authors.size).to eq 1
      expect(edition.books[1].authors[0].name).to eq 'author B'

      expect(edition.publisher).to be_persisted
      expect(edition.publisher.name).to eq 'some publisher'

      expect(edition.category).to be_persisted
      expect(edition.category.code).to eq 'comics'
    end

    context 'params contain no books' do
      let(:raw_params) { super().except(:books) }

      it 'returns built Edition with errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        edition = subject
        expect(edition.errors[:books]).to be_present
      end
    end

    context 'when some author is invalid' do
      let(:raw_params) do
        super().tap do |params|
          params[:books].first[:authors] << ''
        end
      end

      it 'returns built Edition with errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        edition = subject
        byebug
      end
    end
  end
end
