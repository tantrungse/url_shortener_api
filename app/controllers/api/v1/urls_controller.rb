class Api::V1::UrlsController < ApplicationController
  def encode
    original_url = params[:original_url]
    return render json: { error: 'Original URL is required' }, status: :unprocessable_entity if original_url.blank?

    url = Url.find_or_initialize_by(original_url: original_url)
    url.save!

    render json: { short_url: url.short_url }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: 'Original URL is invalid' }, status: :unprocessable_entity
  end

  def decode
    short_url = params[:short_url]
    return render json: { error: 'Short url is required' }, status: :unprocessable_entity if short_url.blank?

    short_code = short_url.split('/').last
    url = Url.find_by!(short_code: short_code)

    render json: { original_url: url.original_url }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Short url not found' }, status: :not_found
  end
end
