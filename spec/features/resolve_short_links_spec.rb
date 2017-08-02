require 'rails_helper'
require 'json'

describe 'resolving shortened links', type: :request do
  let!(:link) { Fabricate.create :link }

  let(:json_headers) do
    { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end

  context 'json format GET to /api/links/:short_name' do
    context 'link exists' do
      it 'returns the orginal_url in expanded format' do
        get api_link_path(link.short_name)

        expect(JSON.parse(response.body)).to eq \
          'original_url' => link.original_url
      end
    end
  end

  context 'http format GET to /l/:short_name' do
    context 'link exists' do
      it 'redirects to the original_url' do
        get "/l/#{link.short_name}"

        expect(response).to redirect_to(link.original_url)
      end
    end

    context 'link does not exist' do
      it 'returns a response with status code 404' do
        get '/l/non-existent'

        expect(response).to have_http_status(404)
      end
    end

    context 'link is expired' do
      let!(:link) { Fabricate.create :link, expiration: 1.day.ago }

      it 'returns a response with status code 404' do
        get "/l/#{link.short_name}"

        expect(response).to have_http_status(404)
      end
    end
  end
end
