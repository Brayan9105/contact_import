require 'rails_helper'

RSpec.describe Book, type: :book do
  describe 'validations' do
    let(:user) { User.create(password: '123456', username: 'testing', email: 'testing@mail.com') }

    describe 'file' do
      context 'when it has wrong format' do
        it 'is not valid' do
          file1 = fixture_file_upload(Rails.root.join("spec", "fixtures", "word.doc") )
          expect(Book.new(file: file1, user_id: user.id).valid?).to be_falsey
        end

        it 'is valid' do
          file1 = fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv") )
          expect(Book.new(file: file1, user_id: user.id).valid?).to be_truthy
        end
      end
    end
  end 
end