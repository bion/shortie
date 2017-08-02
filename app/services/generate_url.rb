class GenerateUrl < ServiceBase
  attr_reader :link, :request

  def initialize(link, request)
    @link = link
    @request = request
  end

  def run
    "#{request.protocol}#{hostname}/l/#{link.short_name}"
  end

  def hostname
    if Rails.configuration.x.include_port_in_url_generation
      request.host_with_port
    else
      request.host
    end
  end
end
