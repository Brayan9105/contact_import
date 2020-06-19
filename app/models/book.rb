class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  enum status: { espera: 0, procesado: 1, fallido: 2, terminado: 3}
  
  validates :file, presence: true
  validate :csv_format

  def csv_format
    unless file.content_type.in?(['text/csv'])
      errors.add(:file, 'Must be a CSV file')
    end
  end

end
