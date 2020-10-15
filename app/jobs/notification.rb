class Notification
  @queue = :notification

  def self.perform

    Book.expired.each do |book|
      UserMailer.with(book: book).reminder.deliver_now
    end
  end
end
