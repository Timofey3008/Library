class BookReserveService
  def initialize(book, user, id)
    @book = book
    @user = user
    @book_id = id
  end

  def call
    Rails.logger.info("- Start #{self.class.name} for User #{@user.id}")

    if @book.find_by(reader_user_id: @user.id)
      return ServiceResult.new(status: false, message: "You already have book. Only one book can be taken")
    end

    return ServiceResult.new(status: false, message: "Book doesn't exist") unless @book.find_by(id: @book_id)

    @book = @book.find(@book_id)

    return ServiceResult.new(status: false, message: "Someone has already taken this book") unless @book.in_library?

    @book.update(status: :reserved, reader_user_id: @user.id, dead_line: DateTime.now + 1.months)
    UserMailer.with(book: @book).book_reserved.deliver_now

    Rails.logger.info("- End #{self.class.name}")
    ServiceResult.new(status: true, message: "Service Complete", data: @book)
  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end
