class Link < ApplicationRecord
  validates :original_url, presence: true
  validates :short_name, uniqueness: true
end
