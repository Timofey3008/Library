class Book < ApplicationRecord
  # has_many :reserveds
  # has_many :users, through: :reserveds
  belongs_to :user, foreign_key: :owner_id
  validates :name, presence: true
  enum status: {in_library: 0, reserved: 1,  picked_up: 2}
end
