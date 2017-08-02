require 'rails_helper'

describe 'POST to /api/links', type: :request do
  context 'valid parameters' do
    let(:url) { 'http://zombo.com' }
    let(:shortened_name) { 'zomcom' }
    let(:link_params) { { original_url: url, short_name: shortened_name } }

    it 'creates a link' do
      expect {
        post api_links_path, { link: link_params }
      }.to change { Link.count }.by(1)

      expect(Link.count).to eq 1
    end
  end
end
