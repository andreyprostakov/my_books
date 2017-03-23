FactoryGirl.define do
  factory :author do
    name { FFaker::Book.author }
  end

  factory :book do
    title { FFaker::Book.title }
    authors { build_list(:author, 1) }

    trait :with_stubbed_relations do
      authors { build_stubbed_list(:author, 1) }
    end
  end

  factory :edition do
    books { build_list(:book, 1) }
    category { EditionCategory.first || build(:edition_category) }
    publisher

    title { FFaker::Book.title }
    isbn { FFaker::Book.isbn }
    annotation { FFaker::Book.description }
    cover { FFaker::Book.cover(size: '200x300') }

    trait :with_stubbed_relations do
      books { build_stubbed_list(:book, 1, :with_stubbed_relations) }
      category { build_stubbed(:edition_category) }
      publisher { build_stubbed(:publisher) }
    end
  end

  factory :edition_category do
    sequence(:code) { |n| "EditionCategory #{n}" }
  end

  factory :book_in_edition do
    book
    edition
  end

  factory :publisher do
    sequence(:name) { |n| "Publisher #{n}" }
  end
end
