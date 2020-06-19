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

  def add_filename
    self.filename = (self.file.filename).to_s.downcase
    self.save
  end

  def processing_file(params)
    fields = ['name', 'date', 'phone', 'address', 'credit_card', 'franchise', 'email']
    file = ActiveStorage::Blob.service.path_for(self.file.key)
    CSV.foreach(file, headers: true) do |row|
      fields.each do |field|
        row[params["#{field}".to_sym].to_i]
      end
    end
  end

  def valid_name
  end

  def valid_date
  end

  def valid_phone
  end

  def valid_address
  end

  def valid_credit_card
  end

  def valid_franchise
  end

  def valid_email
  end

end
