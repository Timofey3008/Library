class User < ApplicationRecord
  has_many :books, foreign_key: :owner_id
  # has_many :reserveds
  # has_many :books, through: :reserveds

  validates :mail, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true
  validates :password, presence: true

  before_create -> {self.token = generate_token}
  before_create :hash_password

  def read_book
    Book.find_by(reader_user_id: id)
  end

  private

  def generate_token
    loop do
      token = SecureRandom.hex
      return token unless User.exists?({token: token})
    end
  end

  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end
end
