class UserMailer < ApplicationMailer
  default from: 'library.ruby.test@gmail.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.mail, subject:  'Successful registration in Library')
  end

  def book_registration
    @user = params[:user]
    @book = params[:book]
    mail(to: @user.mail, bcc: 'tim148@mail.ru', subject: "#{@book.name} successfully registered")
  end

  def book_reserved
    @book = params[:book]
    @owner = User.find(@book.owner_id)
    @user = User.find(@book.reader_user_id)
    mail(to: @user.mail, cc: @owner.mail, bcc: 'tim148@mail.ru', subject: "Book #{@book.name} was successfully reserved")
  end

  def reminder
    @book = params[:book]
    @user = User.find(@book.reader_user_id)
    mail(to: @user.mail, bcc: 'tim148@mail.ru', subject: 'You need to return book to the Library')
  end

  def return
    @book = params[:book]
    @owner = User.find(@book.owner_id)
    @user = User.find(@book.reader_user_id)
    mail(to: @user.mail, cc: @owner.mail, bcc: 'tim148@mail.ru', subject: "Book #{@book.name} was returned to the Library")
  end

  def return_to_owner
    @book = params[:book]
    @owner = User.find(@book.owner_id)
    @user = User.find(@book.reader_user_id)
    mail(to: @user.mail, cc: @owner.mail, bcc: 'tim148@mail.ru', subject: "Owner requested return his book #{@book.name}")
  end

  def returned
    @book = params[:book]
    @owner = User.find(@book.owner_id)
    mail(to: @owner.mail, bcc: 'tim148@mail.ru', subject: "Your book #{@book.name} returned")
  end
end
