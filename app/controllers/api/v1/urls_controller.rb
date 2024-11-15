class Api::V1::UrlsController < ApplicationController
  def encode
    service = ShortenUrlService.new(params[:original_url])
    result = service.call

    if result[:error]
      render json: { error: result[:error] }, status: result[:status]
    else
      render json: { short_url: result[:short_url], short_code: result[:short_code] }, status: result[:status]
    end
  end

  def decode
    short_code = params[:short_code]
    return render json: { error: 'Short code is required'}, status: :unprocessable_entity if short_code.blank?

    url = Url.find_by!(short_code: short_code)

    render json: { original_url: url.original_url}, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Short code not found' }, status: :not_found
  end
end
