require 'rails_helper'

RSpec.describe Book, type: :book do
  describe 'validations' do
    let(:user) { User.create(password: '123456', username: 'testing', email: 'testing@mail.com') }
    let(:book) { Book.create(file: fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv")) )}

    describe 'file' do
      context 'when it has wrong format' do
        it 'is not valid' do
          file1 = fixture_file_upload(Rails.root.join("spec", "fixtures", "word.doc") )
          expect(Book.new(file: file1, user_id: user.id).valid?).to be_falsey
        end
      end  

      context 'when it has correct format' do
        it 'is valid' do
          file1 = fixture_file_upload(Rails.root.join("spec", "fixtures", "contacts.csv") )
          expect(Book.new(file: file1, user_id: user.id).valid?).to be_truthy
        end
      end

      context 'add a filename to the file record' do
        it 'must have return the name of the file' do
          book.add_filename
          expect(book.filename).to eq("contacts.csv")
        end
      end

    end#file
  end 
end