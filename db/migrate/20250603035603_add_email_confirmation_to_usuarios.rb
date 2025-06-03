class AddEmailConfirmationToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :confirmation_token, :string
    add_column :usuarios, :confirmed_at, :datetime
  end
end
