require 'rails_helper'

RSpec.describe 'contacts invalid_contact', type: :feature do
  before do
    @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
    @contact = Contact.create(name: 'Sandra', date: '19-06-2009', phone: '(+67) 333 222 11 11', address: 'some address', credit_card: '1111222333444', franchise: 'visa', email: 'some@mail.com', is_ok: true, user_id: @user.id, book_id: @book.id)
    @contact = Contact.create(name: 'Pablo', date: '19-06-2009', phone: '333 222 11 11', address: 'some address', credit_card: '1111222333444', franchise: 'visa', email: 'some2@mail.com', is_ok: false, user_id: @user.id, book_id: @book.id)
  end

  describe 'contacts invalid_contact' do

    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'testing@mail.com')
      fill_in('Password', with: '123456')
      click_button('Log in')
      visit '/invalid_contacts'
    end

    scenario 'visit invalid_contact' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('Invalid contacts')
      expect(page).to have_no_content('Sandra')
      expect(page).to have_no_content('true')

      expect(page).to have_content('Pablo')
      expect(page).to have_content('false')
    end

    scenario 'visit contact 1' do
      click_on 'view'
      expect(page).to have_http_status(200)
      expect(page).to have_content('Pablo')
    end

  end
end