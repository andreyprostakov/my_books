require 'rails_helper'

RSpec.describe EditionCreateFormHandler do
  let(:handler) { described_class.new(params) }

  describe '#create_edition' do
    subject { handler.create_edition }
    let(:edition) { subject }

    let(:params) { double :params }
    let(:edition_params) { double :edition_params }
    let(:raw_params) do
      {
        books: [
          {
            title: 'book title 1',
            authors: [
              { name: 'author A' },
              { name: 'author B' }
            ]
          },
          {
            title: 'book title 2',
            authors: [
              { name: 'author B' }
            ]
          }
        ],
        title: 'some edition title',
        annotation: 'some annotation',
        isbn: 'X-X-X',
        category: {
          code: 'comics'
        },
        publisher: {
          name: 'some publisher'
        },
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

      it 'returns built edition with books errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        expect(edition.errors[:books]).to be_present
      end
    end

    context 'when some book is invalid' do
      let(:raw_params) do
        super().tap do |params|
          params[:books].first[:authors] << { name: '' }
        end
      end

      it 'returns built edition with books errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        expect(edition).to be_new_record
        expect(edition).not_to be_valid
        expect(edition.errors['books[0].authors[2].name']).to be_present
      end
    end

    context 'when some author is invalid' do
      let(:raw_params) do
        super().tap do |params|
          params[:books] << { title: '' }
        end
      end

      it 'returns built edition with author errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        expect(edition).to be_new_record
        expect(edition).not_to be_valid
        expect(edition.errors['books[2].title']).to be_present
      end
    end

    context 'when category is invalid' do
      let(:raw_params) do
        super().merge(category: { code: 'unknown category' })
      end

      it 'returns built edition with category errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        expect(edition).to be_new_record
        expect(edition).not_to be_valid
        expect(edition.errors['category']).to be_present
      end
    end

    context 'when publisher is invalid' do
      let(:raw_params) do
        super().merge(publisher: { name: '' })
      end

      it 'returns built edition with publisher errors' do
        expect { subject }.not_to change { [Edition.count, Author.count, Publisher.count] }
        expect(edition).to be_new_record
        expect(edition).not_to be_valid
        expect(edition.errors['publisher.name']).to be_present
      end
    end
  end
end
