class Book < ApplicationRecord
  belongs_to :user, foreign_key: :owner_id
  validates :name, presence: true
  enum status: {in_library: 0, reserved: 1, picked_up: 2}
  scope :expired, -> { where("dead_line < ?", Time.now.to_date) }

  def email_reminder
    Book.expired.each do |book|
      UserMailer.with(book: book).reminder.deliver_now
    end
  end
end
