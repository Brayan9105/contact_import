class Book < ApplicationRecord
  belongs_to :user
  has_many :contacts
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

  $contact = { errors: []}

  def processing_file(params)
    fields = ['name', 'date', 'phone', 'address', 'franchise', 'email']
    valid_contact = 0

    file = ActiveStorage::Blob.service.path_for(self.file.key)
    CSV.foreach(file, headers: true) do |row|
      $contact = { errors: [], user_id: self[:user_id] }

      fields.each do |field|
          send("valid_#{field}", row[params["#{field}".to_sym].to_i])
      end

      valid_contact += 1 if $contact[:errors].size == 0
      create_contact($contact)
    end
    valid_contact > 0 ? self.terminado! : self.fallido!    
  end

  def valid_name(name)
    $contact[:name] = name
    if name.present? 
      add_format_error('name') if name.match(/[!$%^&*()_+|~=`{}\[\]:";'<>?,.Ç¨\|@#¢∞¬÷“”≠´\\]/)
    else
      add_blank_error('name')
    end
  end

  def valid_date(date)
    $contact[:date] = date
    if date.present?
      begin
        Date.iso8601(date)
      rescue
        add_format_error('date')
      end
    else
      add_blank_error('date')
    end
  end

  def valid_phone(phone)
    $contact[:phone] = phone
    if phone.present?
      regex1 = /^[\(]\+[\d]{2}[\)][ ][\d]{3}[ ][\d]{3}[ ][\d]{2}[ ][\d]{2}$/
      regex2 = /^[\(]\+[\d]{2}[\)][ ][\d]{3}[-][\d]{3}[-][\d]{2}[-][\d]{2}$/
      add_format_error('phone') unless phone.match(regex1) || phone.match(regex2)
    else
      add_blank_error('phone')
    end
  end

  def valid_address(address)
    $contact[:address] = address
    add_blank_error('address') unless address.present?    
  end

  def valid_credit_card(franchise, credit_card_number)
    case franchise
      when 'mastercard', 'visa', 'discover', 'jcb'
        add_format_error('length') if credit_card_number.size != 16
      when 'american express'
        add_format_error('length') if credit_card_number.size != 15
      when 'dinner club'
        add_format_error('length') if credit_card_number.size != 14
    end
  end

  def valid_franchise(credit_card_number)
    if credit_card_number.present?
      $contact[:card_digit] = credit_card_number[credit_card_number.size-4..credit_card_number.size]

      $contact[:franchise] = case credit_card_number
        when /^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$/#mastercard - 16
          'mastercard'
        when /^4[0-9]{6,}$/#visa - 16
          'visa'
        when /^3[47][0-9]{5,}$/#americanexpress - 15
          'american express'
        when /^3(?:0[0-5]|[68][0-9])[0-9]{4,}$/#dinnersclub - 14
          'dinner club'
        when /^6(?:011|5[0-9]{2})[0-9]{3,}$/#discover - 16
          'discover'
        when /^(?:2131|1800|35[0-9]{3})[0-9]{3,}$/#jcb - 16
          'jcb'
        else
          'unknow'
      end

      $contact[:franchise] != 'unknow' ? valid_credit_card($contact[:franchise], credit_card_number) : add_format_error('franchise')
    else
      add_blank_error('franchise')
    end

    $contact[:credit_card] = BCrypt::Password.create(credit_card_number)

  end

  def valid_email(email)
    $contact[:email] = email
    if email.present?
      regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      if email.match(regex)
        current_user = User.find(self[:user_id])
        add_format_error('email_exists') if current_user.contacts.where(email: email, is_ok: true).exists?
      else
        add_format_error('email')
      end
    else
      add_blank_error('email')
    end
  end

  def add_blank_error(field)
    $contact[:errors] << "field #{field} is blank"
  end

  def add_format_error(field)
    case field
      when 'franchise'
        $contact[:errors] << "unknow franchise"
      when 'length'
        $contact[:errors] << "invalid length of credit card number"
      when 'email_exist'
        $contact[:errors] << "another valid contact has this email"
      else
        $contact[:errors] << "bad format in #{field} field"
    end
  end

  def create_contact(params)
      contact = self.contacts.create(params.except(:errors))
      
      unless params[:is_ok]
        params[:errors].each do |error|
          contact.messages.create(description: error)
        end
      end
  end
end
