require 'rails_helper'

describe 'resolving shortened links', type: :request do
  context 'http format GET to /l/:short_name' do
    context 'link exists' do
      let!(:link) { Fabricate.create :link }

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
