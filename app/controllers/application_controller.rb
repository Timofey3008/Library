class ApplicationController < ActionController::API
  private
  def error_message
    {code:401, status:'Unauthorized', data:{message: "Unauthorized access in the API"}}.to_json
  end
  def authenticate
    authenticate_or_request_with_http_token('Application', error_message ) do |token, options|
      @user = User.find_by(token: token)
    end
    # unless @user.present?
    #   # You could return anything you want if the response if it's unauthorized. in this
    #   # case I'll just return a json object

    end
  end

