require 'securerandom'

class CreateLink < ServiceBase
  attr_reader :params

  SHORT_NAME_LENGTH = 6

  PARAM_LIST = %i[
    original_url
    short_name
    expiration_type
    expiration_units
  ]

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
    link_params = params.slice(:short_name, :original_url)

    unless params.has_key?(:short_name)
      link_params.merge!(short_name: SecureRandom.hex(SHORT_NAME_LENGTH))
    end

    if no_expiration_specified?
      link_params.merge!(expiration: 1.week.from_now)
    elsif expiration_type_days?
      days = params[:expiration_units] || 7

      link_params.merge!(expiration: days.days.from_now)
    elsif does_not_expire?
      link_params.merge!(expiration: nil)
    end

    link_params
  end

  def no_expiration_specified?
    !params.has_key?(:expiration_type)
  end

  def expiration_type_days?
    params[:expiration_type]&.downcase == 'days'
  end

  def does_not_expire?
    params[:expiration_type]&.downcase == 'none'
  end
end
