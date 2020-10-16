class ReturnToOwnerService

  def initialize(book, user, book_id)
    @book = book
    @book_id = book_id
    @user = user
  end

  def call
    @book = @book.find_by(id: @book_id, owner_id: @user.id)
    return ServiceResult.new(status: false, message: "User don't have this book") unless @book.present?
    if @book.reader_user_id.present? and @book.reader_user_id != @user.id
      UserMailer.with(book: @book).return_to_owner.deliver_now
      ServiceResult.new(status: true, message: "Service Complete", data: @book)
    else
      return ServiceResult.new(status: false, message: "User already took his book") if @book.status == 'picked_up'
      UserMailer.with(book: @book).returned.deliver_now
      @book.update(status: :picked_up, reader_user_id: nil, dead_line: nil)
      ServiceResult.new(status: true, message: "Service Complete", data: @book)
    end
  rescue => e
    ServiceResult.new(
        status: false,
        exception: e,
        message: e.message
    )
  end
end

