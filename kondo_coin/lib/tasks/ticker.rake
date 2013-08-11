require 'ticker_tools'

namespace :ticker do
  desc "Update the ticker table with most recent BTC quotes"
  task update: :environment do
    puts "Pulling quotes from Bitstamp & ECB."
    @updater = TickerUpdater.new()
    @updater.store_snapshot
    last_tick = Ticker.last(1)[0]
    puts "#{last_tick.timestamp}: USD #{last_tick.btc_usd}, EUR #{last_tick.btc_eur}"
  end
end
