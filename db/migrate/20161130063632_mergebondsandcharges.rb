class Mergebondsandcharges < ActiveRecord::Migration
  def change
    drop_table :bonds
    add_column :charges, :bond_amount, :float
  end
end
