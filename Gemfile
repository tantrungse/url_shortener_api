source "https://rubygems.org"
ruby "3.3.6"

gem "rails", "~> 7.1.5"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "factory_bot_rails"
gem "pg"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "validate_url"
end

group :development do
  gem "web-console", "4.2.0"
end

group :test do
  gem "shoulda-matchers"
end
