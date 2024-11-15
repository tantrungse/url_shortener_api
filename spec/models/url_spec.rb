require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { Url.create(original_url: "https://example.com/my-original-url", short_code: "abc1234") }

  it 'has a valid model' do
    expect(url).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:original_url) }
    it { is_expected.to validate_uniqueness_of(:original_url) }
    it { is_expected.to validate_presence_of(:short_code) }
    it { is_expected.to validate_uniqueness_of(:short_code) }
    it { is_expected.to validate_url_of(:original_url) }
    it { expect(url.short_code.length).to eq(7) }
  end
end
