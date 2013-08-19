class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.integer :voucher_id
      t.string :wallet
      t.float :payout_value

      t.timestamps
    end
  end
end
