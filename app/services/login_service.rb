class LoginService

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @user = @user.find_by(mail: @params.require(:user).require(:mail))
    return ServiceResult.new(status: false, message: "Incorrect credentials") unless @user.present?
    if BCrypt::Password.new(@user.password) == @params.require(:user).require(:password)
      ServiceResult.new(status: true, message: "Service Complete", data: @user.token)
    else
      ServiceResult.new(status: false, message: "Incorrect credentials")
    end
  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end
