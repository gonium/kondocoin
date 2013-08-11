class AddTimestampToTickers < ActiveRecord::Migration
  def change
    add_column :tickers, :timestamp, :datetime
  end
end
