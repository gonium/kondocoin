class AddWalletToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :wallet, :string
  end
end
