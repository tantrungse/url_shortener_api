require "rails_helper"

RSpec.describe ShortenUrlService do
  describe "#call" do
    let(:original_url) { "https://example.com/another-long-url" }

    context "when the original_url is provided" do
      context "and valid" do
        it "returns a short_code" do
          service = ShortenUrlService.new(original_url)
          result = service.call
  
          expect(result[:short_code]).to be_present
          expect(result[:status]).to eq(:created)
        end
  
        it "does not create duplicate entries for the same URL" do
          service = ShortenUrlService.new(original_url)
          first_result = service.call
          second_result = service.call
  
          expect(first_result[:short_code]).to eq(second_result[:short_code])
          expect(Url.where(original_url: original_url).count).to eq(1)
        end
      end

      context "but invalid" do
        it "returns an error" do
          service = ShortenUrlService.new("invalid-url")
          result = service.call

          expect(result[:error]).to eq("Validation failed: Original url is not a valid URL")
          expect(result[:status]).to eq(:unprocessable_entity)
        end
      end
    end

    context "when the original_url is blank" do
      it "returns an error" do
        service = ShortenUrlService.new(nil)
        result = service.call

        expect(result[:error]).to eq("Original URL is required")
        expect(result[:status]).to eq(:unprocessable_entity)
      end
    end
  end
end
