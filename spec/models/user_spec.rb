require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'email' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(User.new(password: '123456', username: 'testing').valid?).to be_falsey
        end
      end

      context 'when it is present but incorrect' do
        it 'is not valid' do
          expect(User.new(password: '123456', username: 'testing', email: 'testingmail.com').valid?).to be_falsey
        end
      end

      context 'when it is present and correct' do
        it 'is valid' do
          expect(User.new(password: '123456', username: 'testing', email: 'testing@mail.com').valid?).to be_truthy
        end
      end
    end#email

    describe 'username' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(User.new(password: '123456', email: 'testing@mail.com').valid?).to be_falsey
        end
      end

      context 'when it is present' do
        it 'is valid' do
          expect(User.new(password: '123456', username: 'testing', email: 'testing@mail.com').valid?).to be_truthy
        end
      end
    end#username

    describe 'password' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(User.new(username: 'testing', email: 'testing@mail.com').valid?).to be_falsey
        end
      end

      context 'when it is present but legth less than 6' do
        it 'is not valid' do
          expect(User.new(password: '12345', username: 'testing', email: 'testing@mail.com').valid?).to be_falsey
        end
      end

      context 'when it is present' do
        it 'is valid' do
          expect(User.new(password: '123456', username: 'testing', email: 'testing@mail.com').valid?).to be_truthy
        end
      end
    end#password

  end
end