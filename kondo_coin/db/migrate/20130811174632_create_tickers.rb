class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.float :btc_usd
      t.float :btc_eur

      t.timestamps
    end
  end
end
