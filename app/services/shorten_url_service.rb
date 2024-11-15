# app/services/shorten_url_service.rb
class ShortenUrlService
  def initialize(original_url)
    @original_url = original_url
  end

  def call
    return { error: 'Original URL is required', status: :unprocessable_entity } if @original_url.blank?

    url = Url.find_or_initialize_by(original_url: @original_url)
    if url.new_record?
      url.short_code = generate_unique_short_code
      url.save!
    end
    short_url = "#{Rails.application.config.x.base_url}#{url.short_code}"

    { short_url: short_url, short_code: url.short_code, status: :created }
  rescue ActiveRecord::RecordInvalid => e
    { error: 'Original URL is invalid', status: :unprocessable_entity }
  end

  private

  def generate_unique_short_code
    loop do
      code = SecureRandom.urlsafe_base64(5)[0, 7]
      break code unless Url.exists?(short_code: code)
    end
  end
end
