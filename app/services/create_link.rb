require 'securerandom'

class CreateLink < ServiceBase
  attr_reader :params

  SHORT_NAME_LENGTH = 6

  def initialize(params)
    @params = params
  end

  def run
    link = Link.new(link_params)

    if link.save
      broadcast :success, link
    else
      broadcast :error, link.errors.full_messages
    end
  end

  private

  def link_params
    unless params.has_key?(:short_name)
      params.merge!(short_name: SecureRandom.hex(SHORT_NAME_LENGTH))
    end

    if params[:expiration]&.downcase == 'none'
      params.merge!(expiration: nil)
    elsif !params.has_key?(:expiration)
      params.merge!(expiration: 1.week.from_now)
    end

    params
  end
end
