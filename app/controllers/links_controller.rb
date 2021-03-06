class LinksController < ApplicationController
  def show
    link = Link.find_by(short_name: params[:short_name])

    if link
      redirect_to link.original_url
    else
      head :not_found
    end
  end
end
