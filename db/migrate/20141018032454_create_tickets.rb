class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :num_booked

      t.timestamps
    end
  end
end
