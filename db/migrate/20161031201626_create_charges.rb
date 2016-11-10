class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string  :jms_id
      t.string  :booking_id
      t.string  :code
      t.string  :description
      t.string  :category
      t.string  :court_case_number
      t.timestamps null: false
    end
  end
end
