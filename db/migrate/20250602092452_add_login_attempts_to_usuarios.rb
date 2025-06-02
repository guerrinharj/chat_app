class AddLoginAttemptsToUsuarios < ActiveRecord::Migration[7.1]
  def change
    add_column :usuarios, :login_attempts, :integer, default: 0
    add_column :usuarios, :last_failed_login_at, :datetime
  end
end