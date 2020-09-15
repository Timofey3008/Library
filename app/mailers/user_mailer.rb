class UserMailer < ApplicationMailer
  default to: 'tim148@mail.ru',
          from: 'notifications@example.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.mail, subject:  'Successful registration in Library')
  end

  def book_registration
    @user = params[:user]
    @book = params[:book]
    mail(to: @user.mail, subject: "#{@book.name} successfully registered")
  end
end
