require 'rails_helper'

RSpec.describe 'User show', type: :feature do
  before(:each) do
    @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
    @contact = Contact.create(name: '', date: '', phone: '', address: '', credit_card: '', franchise: '', email: '', is_ok: true, user_id: @user.id, book_id: @book.id)
  end

  describe 'user show' do

    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'testing@mail.com')
      fill_in('Password', with: '123456')
      click_button('Log in')
      visit '/users/1'
    end

    scenario 'visit user profile' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('testing@mail.com')
      expect(page).to have_content('testing')
      expect(page).to have_content('Last 5 books')
      expect(page).to have_content('Last 5 contacts')
    end

    scenario 'click on books' do
      click_on 'Books'
      expect(page).to have_http_status(200)
      expect(page).to have_content('My books')
      expect(page).to have_content('Import new book')
    end

    scenario 'click on contacts' do
      click_on 'Contacts'
      expect(page).to have_http_status(200)
      expect(page).to have_content('All contacts')
    end
    
    scenario 'click on all' do
      click_on 'All'
      expect(page).to have_http_status(200)
      expect(page).to have_content('All contacts')
    end

    scenario 'click on valid contacts' do
      click_on 'Valid contact'
      expect(page).to have_http_status(200)
      expect(page).to have_content('Valid contacts')
    end

    scenario 'click on contacts' do
      click_on 'Invalid contact'
      expect(page).to have_http_status(200)
      expect(page).to have_content('Invalid contacts')
    end
  end
end