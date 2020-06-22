class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :date
      t.string :phone
      t.string :address
      t.string :credit_card
      t.string :card_digit
      t.string :franchise
      t.string :email
      t.boolean :is_ok
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
