class ContactsController < ApplicationController
  def show
    @contact = Contact.find(params[:id])
  end

  def all_contact
    @contacts = current_user.contacts
  end

  def valid_contact
    @contacts = current_user.contacts.where(is_ok: true)
  end

  def invalid_contact
    @contacts = current_user.contacts.where(is_ok: false)
  end
end
