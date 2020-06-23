class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @valid_contacts = @user.contacts.where(is_ok: true)
    @invalid_contacts = @user.contacts.where(is_ok: false)
    @last_contacts = @user.contacts.last(5)
    @books = @user.books
  end
end
