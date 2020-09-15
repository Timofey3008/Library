# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.last).welcome_email
  end

  def book_registration
    UserMailer.with(book: Book.first, user: User.last).book_registration
  end

  def book_reserved
    UserMailer.with(book: Book.last).book_reserved
  end

  def reminder
    UserMailer.with(book: Book.last).reminder
  end
end
