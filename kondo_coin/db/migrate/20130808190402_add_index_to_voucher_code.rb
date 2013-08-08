class AddIndexToVoucherCode < ActiveRecord::Migration
  def change
    add_index :vouchers, :code, unique: true
  end
end
