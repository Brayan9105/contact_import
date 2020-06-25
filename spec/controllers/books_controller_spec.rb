require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'actions' do
    describe 'user athenticate' do
      
      before(:each) do
        @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
        @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
        sign_in @user
      end

      describe 'new' do
        context 'get new' do
          it 'return a 200 status' do
            get :new
            expect(response).to have_http_status(200)
          end

          it 'render new template' do
            get :new
            expect(response).to render_template(:new)
          end
        end      
      end#new
      
      describe 'create' do
        context 'post create' do
          it 'redirect to the book created' do
            post :create, params: {book: {file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id}}
            expect(response).to redirect_to(Book.last)
          end

          it 'render new' do
            post :create, params: {book: {file: fixture_file_upload(Rails.root.join("spec", "fixtures", "word.doc")), user_id: @user.id}}
            expect(response).to render_template(:new)
          end
        end
      end#create

      describe 'index' do
        context 'get index' do
          it 'return a 200 status' do
            get :index
            expect(response).to have_http_status(200)
          end

          it 'render index template' do
            get :index
            expect(response).to render_template(:index)
          end

          it 'assigns user books to @books' do
            get :index
            expect(assigns(:books)).to eq([@book])
          end
        end  
      end#index
      
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

          it 'assigns user book to @book' do
            get :show, params: {id: '1'}
            expect(assigns(:book)).to eq(@book)
          end
        end
      end#show

    end

    describe 'user not authenticate' do
      before(:each) do
        @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
        @book = Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id)
      end

      describe 'new' do
        context 'get new' do
          it 'return a 302 status' do
            get :new
            expect(response).to have_http_status(302)
          end

          it 'redirect to sign in' do
            get :new
            expect(response).to redirect_to(new_user_session_path)            
          end
        end      
      end#new
      
      describe 'create' do
        context 'post create' do
          it 'return a 302 status' do
            post :create, params: {book: {file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")), user_id: @user.id}}
            expect(response).to have_http_status(302)
          end
        end
      end#create

      describe 'index' do
        context 'get index' do
          it 'return a 302 status' do
            get :index
            expect(response).to have_http_status(302)
          end

          it 'redirect to sign in' do
            get :index
            expect(response).to redirect_to(new_user_session_path)
          end
        end  
      end#index
      
      describe 'show' do
        context 'get show' do
          it 'return a 302 status' do
            get :show, params: {id: '1'}
            expect(response).to have_http_status(302)
          end

          it 'redirect to sign in' do
            get :show, params: {id: '1'}
            expect(response).to redirect_to(new_user_session_path)
          end
        end
      end#show
    end#no authenticate

  end#actions
end