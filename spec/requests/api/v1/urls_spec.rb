require "rails_helper"

RSpec.describe "Api::V1::Urls", type: :request do
  describe "POST /encode" do
    let(:url) { build(:url) }
  
    context "when the request is valid" do
      it "creates a short_url for the valid original_url" do
        post api_v1_encode_url, params: { original_url: url.original_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("short_url")
      end

      it "handles an extremely long URL" do
        long_url = "https://example.com/" + "a" * 1000
        post api_v1_encode_url, params: { original_url: long_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("short_url")
      end

      it "handles a very short URL" do
        short_original_url = "https://a.co"
        post api_v1_encode_url, params: { original_url: short_original_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("short_url")
      end
    end

    context "when the request is invalid" do
      it "returns an error for missing original_url" do
        post api_v1_encode_url, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Original url is required")
      end

      it "returns an error for an invalid url" do
        post api_v1_encode_url, params: { original_url: "invalid-url" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Original url is invalid")
      end
    end

    context "when the same URL is encoded multiple times" do
      it "returns the same short_url for duplicate URLs" do
        post api_v1_encode_url, params: { original_url: url.original_url }
        first_response_url = JSON.parse(response.body)["short_url"]

        post api_v1_encode_url, params: { original_url: url.original_url }
        second_response_url = JSON.parse(response.body)["short_url"]

        expect(first_response_url).to eq(second_response_url)
        expect(Url.where(original_url: url.original_url).count).to eq(1)
      end
    end
  end

  describe "GET /decode" do
    let(:url) { build(:url) }

    context "when the request is valid" do
      it "returns the original URL by created short_url" do
        post api_v1_encode_url, params: { original_url: url.original_url }
        response_short_url = JSON.parse(response.body)["short_url"]

        get api_v1_decode_url, params: { short_url: response_short_url }
        response_original_url = JSON.parse(response.body)["original_url"]

        expect(response).to have_http_status(:success)
        expect(response_original_url).to eq(url.original_url)
      end

      it "returns the same original URLs by the same created short_url" do
        post api_v1_encode_url, params: { original_url: url.original_url }
        response_short_url = JSON.parse(response.body)["short_url"]

        get api_v1_decode_url, params: { short_url: response_short_url }
        first_response_url = JSON.parse(response.body)["original_url"]

        get api_v1_decode_url, params: { short_url: response_short_url }
        second_response_url = JSON.parse(response.body)["original_url"]

        expect(first_response_url).to eq(second_response_url)
        expect(Url.where(original_url: url.original_url).count).to eq(1)
      end

      it "handles short_url case sensitivity correctly" do
        post api_v1_encode_url, params: { original_url: url.original_url }
        response_short_url = JSON.parse(response.body)["short_url"]
  
        get api_v1_decode_url, params: { short_url: response_short_url.upcase }
  
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Short url not found")
      end
    end

    context "when the request is invalid" do
      it "returns an error for missing short_url" do
        get api_v1_decode_url, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Short url is required")
      end

      it "returns an error for blank short_url" do
        get api_v1_decode_url, params: { short_url: "" }
  
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Short url is required")
      end

      it "returns an error for not found short_url" do
        get api_v1_decode_url, params: { short_url: "notfoundcode" }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include("error" => "Short url not found")
      end
    end
  end
end
