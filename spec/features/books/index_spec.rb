require 'rails_helper'

RSpec.describe 'Books index', type: :feature do
  before(:each) do
    @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
  end

  describe 'book index' do

    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'testing@mail.com')
      fill_in('Password', with: '123456')
      click_button('Log in')
      visit '/books'
    end

    scenario 'visit books new' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('My books')
    end

    scenario 'visit books new' do
      click_on 'Import new book'
      expect(page).to have_http_status(200)
      expect(page).to have_content('New book')
    end

    scenario 'visit books new' do
      click_on 'view'
      expect(page).to have_http_status(200)
      expect(page).to have_content('contacts.csv')
    end
  end
end