class UserCreateService

  def initialize(user, user_params)
    @user = user
    @user_params = user_params
  end

  def call

    @user = @user.new(@user_params)
    if @user.save
      UserMailer.with(user: @user).welcome_email.deliver_now
      ServiceResult.new(status: true, message: "Service Complete", data: @user)
    else
      ServiceResult.new(status: false, message: @user.errors)
    end
  end
end
