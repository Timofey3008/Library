class ApplicationController < ActionController::API
  private

  def render_success(code: 200, status: :OK, data: [])
    render json: {code: code, status: status, data: data}
  end

  def render_error(code: 400, status: 'Bad Request', data: [])
    render json: {code: code, status: status, data: data}, status: :bad_request
  end

  def render_forbidden(code: 403, status: 'Forbidden', data: [])
    render json: {code: code, status: status, data: data}, status: :forbidden
  end

  def render_created(code: 201, status: 'Created', data: [])
    render json: {code: code, status: status, data: data}, status: :created
  end

  def error_message
    {code: 401, status: 'Unauthorized', data: "Unauthorized access in the API"}.to_json
  end

  def authenticate
    authenticate_or_request_with_http_token('Application', error_message) do |token, options|
      @user = User.find_by(token: token)
    end
  end
end

