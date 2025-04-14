class CreateUser < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.string :email, limit: 50, null: false
      t.string :password_digest, limit: 100, null: false
      t.string :phone_number, limit: 10, null: false
      t.string :role, limit: 10, null: false, default: 'customer'
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_check_constraint :users, "role IN ('customer', 'admin')", name: 'role_check'

    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
  end
end

