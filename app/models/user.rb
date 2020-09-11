class User < ApplicationRecord

  validates :mail, presence: true, uniqueness: true
  validates :password, presence: true

  before_create -> {self.token = generate_token}
  before_create :hash_password

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
