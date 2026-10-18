class CreateAdminUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :admin_users, "lower(email)", unique: true, name: "index_admin_users_on_lower_email"
  end
end
