class CreateMensagems < ActiveRecord::Migration[7.1]
  def change
    create_table :mensagems do |t|
      t.text :texto
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
