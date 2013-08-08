class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string :code
      t.float :eurovalue
      t.string :state

      t.timestamps
    end
  end
end
