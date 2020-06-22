class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :messages
end
