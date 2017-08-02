require 'rails_helper'

describe Link do
  describe 'validations' do
    it 'is invalid without an original url' do
      link = Link.new(short_name: 'foo')

      expect(link).to_not be_valid
      expect(link.errors.full_messages).to eq ["Original url can't be blank"]
    end

    it 'is invalid if an existing link already has the same url' do
      Fabricate.create :link, short_name: 'taken'

      link = Link.new(short_name: 'taken', original_url: 'foo')
      expect(link).to_not be_valid
    end
  end

  describe 'the default scope' do
    let!(:expired_link) { Fabricate.create(:link, expiration: 1.day.ago) }
    let!(:wont_expire_link) { Fabricate.create(:link, expiration: nil) }
    let!(:will_expire_link) { Fabricate.create(:link, expiration: 1.day.from_now) }

    it 'does not include expired links' do
      expect(Link.all).to match_array([wont_expire_link, will_expire_link])
    end
  end
end
