class CreateCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :login
      t.string :password
      t.string :server_type
      t.boolean :in_use
      t.boolean :default

      t.timestamps
    end
  end
end
