class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nombre
      t.string :apellidos
      t.string :email
      t.date :incorporacion
      t.boolean :baja
      t.timestamps null: false
    end
  end
end
