require 'rails_helper'

RSpec.describe 'Books show', type: :feature do
  before(:each) do
    @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
  end

  describe 'book show' do

    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'testing@mail.com')
      fill_in('Password', with: '123456')
      click_button('Log in')
      visit '/books/1'
    end

    scenario 'visit books show' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('contacts.csv')
      expect(page).to have_content('espera')
      expect(page).to have_content('Name')
      expect(page).to have_content('Date')
      expect(page).to have_content('Phone')
      expect(page).to have_content('Address')
      expect(page).to have_content('Franchise')
      expect(page).to have_content('Email')
      expect(page).to have_content('Processing')
    end
  end
end