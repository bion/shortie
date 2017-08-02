class Link < ApplicationRecord
  validates :original_url, :short_name, presence: true
  validates :short_name, uniqueness: true

  default_scope do
    where('expiration >= ? OR expiration IS NULL', DateTime.now)
  end
end
