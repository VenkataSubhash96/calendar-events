class CreateAttendants < ActiveRecord::Migration[5.2]
  def change
    create_table :attendants do |t|
      t.integer 'user_id'
      t.integer 'event_id'
      t.string 'status'
      t.text 'notes'
      t.timestamps
    end
  end
end
