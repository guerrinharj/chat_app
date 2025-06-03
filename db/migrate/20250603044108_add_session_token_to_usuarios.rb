class AddSessionTokenToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :session_token, :string
  end
end
