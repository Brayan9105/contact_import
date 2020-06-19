class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  enum status: { espera: 0, procesado: 1, fallido: 2, terminado: 3}
end
