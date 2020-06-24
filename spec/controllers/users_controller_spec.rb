require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'actions' do
    before(:each) do
      @user = User.create(password: '123456', username: 'testing', email: 'testing@mail.com')
    end

    describe 'show' do
      context 'get show with a authenticate user' do
        before(:each) do
          sign_in @user
        end

        it 'return a 200 status' do
          get :show, params: {id: 1}
          expect(response).to have_http_status(200)
        end

        it 'return a 200 status' do
          get :show, params: {id: 1}
          expect(response).to render_template(:show)
        end

      end

      context 'get show without a authenticate user' do
        it 'return a 200 status' do
          get :show, params: {id: 1}
          expect(response).to have_http_status(302)
        end
      end
    end#show
  end
end