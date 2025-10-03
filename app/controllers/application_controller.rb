class ApplicationController < ActionController::API
  before_action :authenticate_api_key!

  rescue_from Errors::GeolocationError, with: :render_geo_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def authenticate_api_key!
    expected = ENV['API_KEY']
    return if expected.blank? # security disabled if not set
    provided = request.get_header('HTTP_X_API_KEY')
    head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(provided.to_s, expected.to_s)
  end

  def render_geo_error(error)
    render json: { errors: [{ title: error.message, code: error.code, meta: error.meta }] },
           status: :unprocessable_entity
  end

  def render_not_found
    render json: { errors: [{ title: 'Not Found' }] }, status: :not_found
  end
end
