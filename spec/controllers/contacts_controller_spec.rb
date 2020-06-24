require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'actions' do
    
    before(:each) do
      @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
      @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
      @contact = Contact.create(name: '', date: '', phone: '', address: '', credit_card: '', franchise: '', email: '', is_ok: true, user_id: @user.id, book_id: @book.id)
    end
    
    describe 'user athenticate' do
      
      before(:each) do
        sign_in @user
      end

      describe 'show' do
        context 'get show' do
          it 'return a 200 status' do
            get :show, params: {id: '1'}
            expect(response).to have_http_status(200)
          end

          it 'render show template' do
            get :show, params: {id: '1'}
            expect(response).to render_template(:show)
          end
        end
      end

      describe 'all_contact' do
        context 'get all_contacts' do
          it 'return a 200 status' do
            get :all_contact
            expect(response).to have_http_status(200)
          end

          it 'render all_contact template' do
            get :all_contact
            expect(response).to render_template("contacts/all_contact")
          end
        end
      end

      describe 'valid_contact' do
        context 'get valid_contacts' do
          it 'return a 200 status' do
            get :valid_contact
            expect(response).to have_http_status(200)
          end

          it 'render valid_contact template' do
            get :valid_contact
            expect(response).to render_template("contacts/valid_contact")
          end
        end
      end

      describe 'invalid_contact' do
        context 'get invalid_contacts' do
          it 'return a 200 status' do
            get :invalid_contact
            expect(response).to have_http_status(200)
          end

          it 'render invalid_contact template' do
            get :invalid_contact
            expect(response).to render_template("contacts/invalid_contact")
          end
        end
      end
    end#authenticate user

    describe 'user not authenticate' do
      describe 'show' do
        context 'get show' do
          it 'return a 302 status' do
            get :show, params: {id: '1'}
            expect(response).to have_http_status(302)
          end

          it 'redirecto to sign in' do
            get :show, params: {id: '1'}
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end

      describe 'all_contact' do
        context 'get all_contacts' do
          it 'return a 302 status' do
            get :all_contact
            expect(response).to have_http_status(302)
          end

          it 'redirecto to sign in' do
            get :all_contact
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end

      describe 'valid_contact' do
        context 'get valid_contacts' do
          it 'return a 302 status' do
            get :valid_contact
            expect(response).to have_http_status(302)
          end

          it 'redirecto to sign in' do
            get :valid_contact
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end

      describe 'invalid_contact' do
        context 'get invalid_contacts' do
          it 'return a 302 status' do
            get :invalid_contact
            expect(response).to have_http_status(302)
          end

          it 'redirecto to sign in' do
            get :invalid_contact
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end
    end#not authenticate user
  end
end