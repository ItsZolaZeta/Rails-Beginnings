class Comment < ApplicationRecord
  belongs_to :pin
  belongs_to :user

  validates :body, presence: true
end
