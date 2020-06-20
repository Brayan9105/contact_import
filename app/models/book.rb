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
    # fields = ['name', 'date']#, 'phone', 'address', 'credit_card', 'franchise', 'email']
    # valid = true
    # valid_contact = 0

    # file = ActiveStorage::Blob.service.path_for(self.file.key)
    # CSV.foreach(file, headers: true) do |row|
    #   fields.each do |field|
    #     valid &&= send("valid_#{field}", row[params["#{field}".to_sym].to_i])

    #     unless valid
    #       #call a method to create a invalid contact with error attached
    #       break
    #     end
    #   end

    #   valid_contact += 1 if valid
    #   p '-----------------------------------'
    # end
    # self.terminado! if valid_contact > 0
    
  end

  def valid_name(name)
    name.match(/[!$%^&*()_+|~=`{}\[\]:";'<>?,.Ç¨\|@#¢∞¬÷“”≠´\\]/) ? false : true
  end

  def valid_date(date)
    begin
      # (Date.parse str).strftime("%Y %B %d")
      Date.iso8601(date)
      true 
    rescue
      false
    end
  end

  def valid_phone(phone)
    regex1 = /^[\(]\+[\d]{2}[\)][ ][\d]{3}[ ][\d]{3}[ ][\d]{2}[ ][\d]{2}$/
    regex2 = /^[\(]\+[\d]{2}[\)][ ][\d]{3}[-][\d]{3}[-][\d]{2}[-][\d]{2}$/
    phone.match(regex1) || phone.match(regex2) ? true : false
  end

  def valid_address(address)
    address.present?
  end

  def valid_credit_card(credit_card)
    p "CREDIT #{credit_card}"
  end

  def valid_franchise(franchise)ex
    p "FRANCHISE #{franchise}"
  end

  def valid_email(email)
    p "Email #{email}"
  end

end
