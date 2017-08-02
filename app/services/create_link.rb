class CreateLink < ServiceBase
  attr_reader :link_params, :request

  def initialize(link_params, request)
    @link_params = link_params
    @request = request
  end

  def run
    link = Link.new(link_params)

    if link.save
      broadcast :success, link
    else
      broadcast :error, link.errors.full_messages
    end
  end
end
