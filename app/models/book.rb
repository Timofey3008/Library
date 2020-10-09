class Book < ApplicationRecord
  # has_many :reserveds
  # has_many :users, through: :reserveds
  belongs_to :user, foreign_key: :owner_id
  validates :name, presence: true
  enum status: {in_library: 0, reserved: 1, picked_up: 2}
  scope :expired, -> {where("dead_line < ?", Time.now.to_date)}

  # after_create :notify
  # after_update :notify_reserv

  def email_reminder
    Book.expired.each do |book|
      UserMailer.with(book: book).reminder.deliver_now
    end
  end

  private

  # def notify
  #   UserMailer.with(book: self, user: user).book_registration.deliver_now
  # end
  #
  # def notify_reserv
  #   return unless status != :reserved
  #
  #   UserMailer.with(book: self).book_reserved.deliver_now
  # end
end
