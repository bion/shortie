class Api::LinksController < Api::BaseController
  def show
    link = Link.find_by(short_name: params[:short_name])

    if link
      render json: { original_url: link.original_url }
    else
      head :gone
    end
  end

  def create
    CreateLink.register_and_run(link_params) do |service|
      service.on :success do |link|
        @short_url = GenerateUrl.run(link, request)

        render status: :created
      end

      service.on :error do |errors|
        @errors = errors

        render status: :bad_request
      end
    end
  end

  private

  def link_params
    params
      .require(:link)
      .permit(CreateLink::PARAM_LIST)
  end
end
