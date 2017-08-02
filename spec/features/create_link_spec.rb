require 'rails_helper'
require 'json'

describe 'POST to /api/links', type: :request do
  let(:url) { 'http://zombo.com' }
  let(:short_name) { 'zomcom' }
  let(:valid_link_params) { { original_url: url, short_name: short_name } }

  let(:json_headers) do
    { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end

  context 'valid parameters' do
    context 'short_name unspecified' do
      def post_valid_params
        post api_links_path,
          params: { link: valid_link_params.slice(:original_url) }.to_json,
          headers: json_headers
      end

      it 'creates a link' do
        expect {
          post_valid_params
        }.to change { Link.count }.by(1)

        expect(Link.count).to eq 1
      end
    end

    context 'short_name specified' do
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

  context 'invalid parameters' do
    context 'short_name is already taken' do
      let!(:previous_link) { Fabricate.create :link, short_name: 'taken' }

      def post_with_taken_name
        post api_links_path,
          params: { link: valid_link_params.merge(short_name: 'taken') }.to_json,
          headers: json_headers
      end

      it 'does not create a link' do
        expect {
          post_with_taken_name
        }.to_not change { Link.count }
      end

      context 'after the request' do
        before do
          post_with_taken_name
        end

        it 'returns a response with status code 400' do
          expect(response).to have_http_status(400)
        end

        it 'returns a json response with the error messages' do
          expect(JSON.parse(response.body)).to eq \
            'errors' => 'Short name has already been taken'
        end
      end
    end

    context 'original_url is missing' do
      def post_without_url
        post api_links_path,
          params: { link: valid_link_params.merge(original_url: nil) }.to_json,
          headers: json_headers
      end

      it 'does not create a link' do
        expect {
          post_without_url
        }.to_not change { Link.count }
      end

      context 'after the request' do
        before do
          post_without_url
        end

        it 'returns a response with status code 400' do
          expect(response).to have_http_status(400)
        end

        it 'returns a json response with the error messages' do
          expect(JSON.parse(response.body)).to eq \
            'errors' => "Original url can't be blank"
        end
      end
    end
  end
end
