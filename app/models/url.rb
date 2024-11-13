class Url < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true, url: true
  validates :short_code, presence: true, uniqueness: true
end
