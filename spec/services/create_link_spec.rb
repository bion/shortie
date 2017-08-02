require 'rails_helper'

describe CreateLink do
  context 'link_params does not include short_name' do
    let(:link_params) { { original_url: 'http://www.zombo.com' } }

    it 'generates a semi-random short_name for the link' do
      subject = CreateLink.new(link_params)

      subject.on :success do |link|
        expect(link).to be_valid
        expect(link.short_name).to be
      end

      expect { subject.run }.to broadcast(:success)
    end
  end

  context "expiration is set to 'none'" do
    let(:link_params) do
      {
        original_url: 'zombo.com',
        short_name: 'foo',
        expiration: 'none'
      }
    end

    it "sets the link's expiration to nil" do
      subject = CreateLink.new(link_params)

      subject.on :success do |link|
        expect(link).to be_valid
        expect(link.expiration).to be nil
      end

      expect { subject.run }.to broadcast(:success)
    end
  end

  context 'expiration is not set' do
    let(:link_params) { { original_url: 'zombo.com', short_name: 'foo' } }

    before do
      Timecop.freeze
    end

    after do
      Timecop.return
    end

    it "set's the link's expiration to six days from now" do
      subject = CreateLink.new(link_params)

      subject.on :success do |link|
        expect(link).to be_valid
        expect(link.expiration).to eq 7.days.from_now
      end

      expect { subject.run }.to broadcast(:success)
    end
  end
end
