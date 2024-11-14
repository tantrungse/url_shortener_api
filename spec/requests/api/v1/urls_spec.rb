require "rails_helper"

RSpec.describe "Api::V1::Urls", type: :request do
  describe "POST /encode" do
    let(:original_url) { "https://example.com/another-long-url" }
  
    context "when the request is valid" do
      it "creates a short code for the valid original_url" do
        post api_v1_encode_url, params: { original_url: original_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('short_code')
        expect(Url.last.original_url).to eq(original_url)
      end

      it 'handles an extremely long URL' do
        long_url = "https://example.com/" + "a" * 1000
        post api_v1_encode_url, params: { original_url: long_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('short_code')
        expect(Url.last.original_url).to eq(long_url)
      end

      it 'handles a very short URL' do
        short_url = "https://a.co"
        post api_v1_encode_url, params: { original_url: short_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('short_code')
        expect(Url.last.original_url).to eq(short_url)
      end
    end

    context "when the request is invalid" do
      it "returns an error for missing original_url" do
        post api_v1_encode_url, params: {}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Original URL is required")
      end

      it "returns an error for an invalid url" do
        post api_v1_encode_url, params: { original_url: "invalid-url" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Validation failed: Original url is not a valid URL")
      end
    end

    context "when the same URL is encoded multiple times" do
      it "returns the same short_code for duplicate URLs" do
        post api_v1_encode_url, params: { original_url: original_url }
        first_response_code = JSON.parse(response.body)["short_code"]

        post api_v1_encode_url, params: { original_url: original_url }
        second_response_code = JSON.parse(response.body)["short_code"]

        expect(first_response_code).to eq(second_response_code)
        expect(Url.where(original_url: original_url).count).to eq(1)
      end
    end
  end
end
