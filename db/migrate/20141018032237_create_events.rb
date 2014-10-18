class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :type
      t.string :date
      t.string :time
      t.string :venue
      t.integer :available_tickets
      t.integer :total_tickets

      t.timestamps
    end
  end
end
