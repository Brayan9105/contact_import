require 'rails_helper'

RSpec.describe 'Boooks new', type: :feature do
  before(:each) do
    @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
  end

  describe 'book new' do

    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'testing@mail.com')
      fill_in('Password', with: '123456')
      click_button('Log in')
      visit '/books/new'
    end

    scenario 'visit books new' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('New book')
    end
  end
end