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
        send("valid_#{field}", row[params["#{field}".to_sym].to_i])
      end
      p '-----------------------------------'
    end
  end

  def valid_name(name)
    p "NAME: #{name}"
  end

  def valid_date(date)
    p "DATE: #{date}"
  end

  def valid_phone(phone)
    p "PHONE #{phone}"
  end

  def valid_address(address)
    p "ADDRESS #{address}"
  end

  def valid_credit_card(credit_card)
    p "CREDIT #{credit_card}"
  end

  def valid_franchise(franchise)
    p "FRANCHISE #{franchise}"
  end

  def valid_email(email)
    p "Email #{email}"
  end

end
