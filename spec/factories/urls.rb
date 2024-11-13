FactoryBot.define do
  factory :url do
    original_url { "https://example.com/my-very-long-url" }
    short_code { "abcd123" }
  end
end
