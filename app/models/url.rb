class Url < ApplicationRecord
  before_validation :set_uniq_short_code, on: :create

  validates :original_url, presence: true, uniqueness: true, url: true
  validates :short_code, presence: true, uniqueness: true

  def short_url
    "#{Rails.application.config.x.base_url}#{short_code}" if short_code.present?
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
