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
end
