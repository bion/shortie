class Api::LinksController < Api::BaseController
  def create
    link = Link.new(link_params)
    link.save

    @short_url = GenerateUrl.run(link)
  end

  private

  def link_params
    params
      .require(:link)
      .permit(:original_url, :short_name)
  end
end
