FactoryGirl.define do
  factory :author do
    name { FFaker::Book.author }
  end

  factory :book do
    title { FFaker::Book.title }
    authors { build_list(:author, 1) }
  end

  factory :edition do
    books { build_list(:book, 1) }

    title { FFaker::Book.title }
    isbn { FFaker::Book.isbn }
    cover_url { FFaker::Book.cover }
    annotation { FFaker::Book.description }
  end

  factory :book_in_edition do
    book
    edition
  end
end
