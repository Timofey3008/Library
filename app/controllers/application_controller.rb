class ApplicationController < ActionController::API
  private

  def error_message
    {code: 401, status: 'Unauthorized', data: {message: "Unauthorized access in the API"}}.to_json
  end

  def authenticate
    authenticate_or_request_with_http_token('Application', error_message) do |token, options|
      @user = User.find_by(token: token)
    end
  end
end

