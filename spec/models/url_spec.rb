require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { build(:url) }

  it 'has a valid factory' do
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
