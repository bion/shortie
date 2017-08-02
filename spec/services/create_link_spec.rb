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
end
