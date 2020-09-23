class ApplicationController < ActionController::API
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(token: token)
      if @user.present?
        # You could return anything you want if the response if it's unauthorized. in this
        # case I'll just return a json object
        return render json: {
            status: 300,
            message: "Unauthorized access in the API"
        }, status: 401
      end
    end
  end
end
