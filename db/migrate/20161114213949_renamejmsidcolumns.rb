class Renamejmsidcolumns < ActiveRecord::Migration
  def change
    rename_column :people, :jms_id, :jms_person_id
    rename_column :bookings, :jms_id, :jms_booking_id
    rename_column :charges, :jms_id, :jms_charge_id
  end
end
