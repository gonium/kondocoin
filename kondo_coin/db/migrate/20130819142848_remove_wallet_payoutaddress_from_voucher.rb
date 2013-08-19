class RemoveWalletPayoutaddressFromVoucher < ActiveRecord::Migration
  def change
    remove_column :vouchers, :wallet, :string
    remove_column :vouchers, :payout_value, :float
  end
end
