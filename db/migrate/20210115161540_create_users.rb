class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string 'user_name', null: false
      t.string 'email', limit: 100, null: false
      t.string 'mobile_number'
      t.timestamps
    end
  end
end
