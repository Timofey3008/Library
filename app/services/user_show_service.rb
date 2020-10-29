class UserShowService

  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    @user = User.find_by(id: @params[:id])

    if @user.present?
      @user = @user.attributes.except('token', 'created_at', 'updated_at', 'password')
      ServiceResult.new(status: true, message: "Service Complete", data: @user)
    else
      ServiceResult.new(status: true, data: @user)
    end

  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end
