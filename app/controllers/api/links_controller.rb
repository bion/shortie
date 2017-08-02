class Api::LinksController < Api::BaseController
  def create
    link = Link.new(link_params)
    link.save
  end

  private

  def link_params
    params.require(:link).permit(:original_url, :shortened_name)
  end
end
