class Url < ApplicationRecord
  MAX_URL_LENGTH = 2048

  before_validation :normalize_original_url
  before_validation :set_uniq_short_code, on: :create

  validates :original_url, presence: true, uniqueness: { case_sensitive: false }, url: true, length: { maximum: MAX_URL_LENGTH }
  validates :short_code, presence: true, uniqueness: true

  def short_url
    "#{Rails.application.config.x.base_url}#{short_code}" if short_code.present?
  end

  def normalize_original_url(original_url = self.original_url)
    return if original_url.blank?

    uri = URI.parse(original_url.strip)
    host = uri&.host&.sub(/\Awww\./, '')
    normalized = "#{uri&.scheme}://#{host&.downcase}#{uri&.path}".chomp('/')
    self.original_url = normalized
  rescue URI::InvalidURIError
    errors.add(:base, 'Original url is invalid')
  end

  private

  def set_uniq_short_code
    self.short_code ||= generate_unique_short_code
  end

  def generate_unique_short_code
    loop do
      code = SecureRandom.urlsafe_base64(5)[0, 7]
      break code unless self.class.exists?(short_code: code)
    end
  end
end
