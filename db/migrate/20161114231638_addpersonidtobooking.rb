class Addpersonidtobooking < ActiveRecord::Migration
  def change
    add_column :bookings, :person_id, :string
  end
end
