class ApplicationController < ActionController::API
  before_action :allow_ajax_request_from_other_domains

  def render_json(data, status = :ok)
    if Rails.env.production? && !params.key?(:debug)
      render json: data, status: status
    else
      render plain: JSON.pretty_generate(data), status: status
    end
  end

  protected

  def allow_ajax_request_from_other_domains
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
