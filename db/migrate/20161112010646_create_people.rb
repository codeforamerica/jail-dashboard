class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :jms_id
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.datetime :date_of_birth
      t.string  :gender
      t.string  :race
      t.timestamps
    end

    remove_column :bookings, :first_name
    remove_column :bookings, :middle_name
    remove_column :bookings, :last_name
    remove_column :bookings, :date_of_birth
    remove_column :bookings, :gender
    remove_column :bookings, :race

  end
end
