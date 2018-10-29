class ApplicationController < ActionController::API

  def rendur(response)
    render json: response.serialize, status: response.code
  end
end
