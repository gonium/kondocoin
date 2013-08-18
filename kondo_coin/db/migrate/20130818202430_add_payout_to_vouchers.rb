class AddPayoutToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :payout_value, :float
  end
end
