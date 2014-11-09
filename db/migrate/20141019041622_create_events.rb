class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_type
      t.datetime :datetime
      t.string :venue
      t.integer :available_tickets
      t.integer :total_tickets
      t.integer :user_id
      
      t.timestamps
    end
  end
end
