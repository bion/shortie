require 'rails_helper'

describe GenerateUrl do
  describe '.run' do
    let(:link) { Fabricate.build(:link, short_name: 'short') }
    let(:request) { double('request') }

    before do
      allow(request).to receive(:host_with_port).and_return('www.test.com')
      allow(request).to receive(:protocol).and_return('https://')
    end

    it 'returns a url for the shortened link' do
      result = described_class.run(link, request)

      expect(result).to eq 'https://www.test.com/l/short'
    end
  end
end
