require 'securerandom'

class CreateLink < ServiceBase
  attr_reader :params

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
    params.has_key?(:short_name) ?
      params :
      params.merge(short_name: SecureRandom.hex(6))
  end
end
