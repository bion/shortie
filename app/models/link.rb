class Link < ApplicationRecord
  validates :original_url, :short_name, presence: true
  validates :short_name, uniqueness: true
end
