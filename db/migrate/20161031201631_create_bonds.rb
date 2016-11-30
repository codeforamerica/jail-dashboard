class CreateBonds < ActiveRecord::Migration
  def change
    create_table :bonds do |t|
      t.string  :charge_id
      t.float :amount
      t.timestamps null: false
    end
  end
end
