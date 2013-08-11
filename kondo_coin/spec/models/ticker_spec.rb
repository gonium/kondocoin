require 'spec_helper'
require 'ticker_tools'
require 'pp'

describe Ticker do

  it { should respond_to(:btc_usd) }
  it { should respond_to(:btc_eur) }
 
  describe "updater" do
    before do
      @updater = TickerUpdater.new()
    end
    it "must create a new entry in the database" do
      startcount = Ticker.count
      @updater.store_snapshot
      endcount = Ticker.count
      expect(endcount - startcount).to eq(1)
    end
    #it "last entry should have a recent timestamp" do
    #  @updater.store_snapshot
    #  last_tick = Ticker.last(1)
    #  expect(DateTime.now - last_tick.timestamp).to be <= 5
    #end

  end

  describe "BTC/USD" do
    describe "must be greater than zero" do
      before {@ticker = Ticker.new(btc_usd: 0.0, btc_eur: 1.0)}
      it { should_not be_valid }
    end
  end

  describe "BTC/EUR" do
    describe "must be greater than zero" do
      before {@ticker = Ticker.new(btc_usd: 1.0, btc_eur: 0.0)}
      it { should_not be_valid }
    end
  end



end
