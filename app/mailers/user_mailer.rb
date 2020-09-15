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

  def book_reserved
    @book = params[:book]
    @owner = User.find(@book.owner_id)
    @user = User.find(@book.reader)
    mail(to: @user.mail, cc: @owner.mail, subject: "Book #{@book.name} was successfully reserved")
  end

  def reminder
    @book = params[:book]
    @user = User.find(@book.reader)
    mail(to: @user.mail, subject: 'You need to return book to the Library')
  end
end
