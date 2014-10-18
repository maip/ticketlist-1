class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :event
      t.integer :num_booked

      t.timestamps
    end
  end
end
