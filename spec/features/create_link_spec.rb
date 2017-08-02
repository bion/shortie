require 'rails_helper'
require 'json'

describe 'POST to /api/links', type: :request do
  context 'valid parameters' do
    let(:url) { 'http://zombo.com' }
    let(:short_name) { 'zomcom' }
    let(:valid_link_params) { { original_url: url, short_name: short_name } }

    let(:json_headers) do
      { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
    end

    def post_valid_params
      post api_links_path,
        params: { link: valid_link_params }.to_json,
        headers: json_headers
    end

    it 'creates a link' do
      expect {
        post_valid_params
      }.to change { Link.count }.by(1)

      expect(Link.count).to eq 1
    end

    context 'after creation' do
      before do
        post_valid_params
      end

      it 'returns a JSON response with the shortened url' do
        expect(JSON.parse(response.body)).to eq \
          'short_url' => 'http://www.example.com/l/zomcom'
      end

      it 'returns a response with status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns a response with content type json' do
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end
