class User < ApplicationRecord
  has_many :books
  has_many :contacts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  validates :email, :password, :username, presence: true
  validates :email, :username, uniqueness: true
  
end
