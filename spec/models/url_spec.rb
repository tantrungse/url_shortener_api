require 'rails_helper'

RSpec.describe Url, type: :model do
  subject { build(:url) }

  it 'has a valid model' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    let(:url) { create(:url) }

    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_uniqueness_of(:original_url).case_insensitive }
    it { is_expected.to validate_url_of(:original_url) }
    it { is_expected.to validate_uniqueness_of(:short_code) }
    it { expect(url.short_code.length).to eq(7) }

    it 'validates presence of short_code' do
      allow(url).to receive(:set_uniq_short_code)
      url.short_code = nil

      expect(url).not_to be_valid
      expect(url.errors[:short_code]).to include("can't be blank")
    end

    it 'is invalid with a URL longer than 2048 characters' do
      long_url = "http://example.com/#{'a' * 2035}"

      url = Url.new(original_url: long_url)
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("is too long (maximum is 2048 characters)")
    end
  end

  describe 'short_code' do
    context 'on create' do
      let(:url) { create(:url) }

      it 'is generated' do
        expect(url.short_code).to be_present
      end

      it 'have 7 characters' do
        expect(url.short_code.size).to eq(7)
      end
    end
  end

  describe '.short_url' do
    let(:url) { create(:url) }

    it 'returns full shortened url' do
      expect(url.short_url).to eq("#{Rails.application.config.x.base_url}#{url.short_code}")
    end
  end

  describe 'URL normalization' do
    it 'normalizes URLs to a consistent format' do
      url = create(:url, original_url: 'https://www.example.com/')
      expect(url.original_url).to eq('https://example.com')
    end

    it 'converts the host to lowercase' do
      url = create(:url, original_url: 'HTTPS://Example.COM/MyPage')
      expect(url.original_url).to eq('https://example.com/MyPage')
    end
  end
end
