require 'spec_helper'
require 'voucher_tools'

describe Payout do
  before do
    @v_factory = VoucherFactory.new();
    # put a faked ticker value into the database
    t=Ticker.create(btc_usd: 2.34,
                    btc_eur: 3.32,
                    timestamp: DateTime.now
                   );
  end


  let (:voucher) do
    @v_factory.create(1)
    voucher = Voucher.last
    voucher.hardcopy! # simulate printing of our voucher.
    return voucher
  end

  before do
    # This code is not idiomatically correct.
    @payout = Payout.new(
                 wallet: "mzTYbXy2pwoLQ3pW6esQHw5XYkJMN8bGS6", 
                 voucher_id: voucher.id,
                 payout_value: 2.00
              )
  end

  subject { @payout }

  it { should respond_to(:voucher_id) }
  it { should respond_to(:wallet) }
  it { should respond_to(:payout_value) }

  describe "voucher_id" do
    describe "must be present" do
      before {@payout.voucher_id = nil}
      it { should_not be_valid }
    end
  end

  describe "payout_value" do
    describe "must be non-negative" do
      before {@payout.payout_value = -1.0}
      it { should_not be_valid }
    end
    describe "must not accept nil value" do
      before {@payout.payout_value = nil}
      it { should_not be_valid }
    end
    describe "must accept zero value" do
      before {@payout.payout_value = 0.0}
      it { should be_valid }
    end
  end

  describe "wallet" do
    describe "cannot be empty" do
      before {@payout.wallet = nil }
      it { should_not be_valid }
    end
    describe "must follow format conventions" do
      before {@payout.wallet = "yadayada" }
      it { should_not be_valid }
    end
    describe "accepts base58 wallet strings (no checksum verification)" do
      before {@payout.wallet = "1HGXxsFArRRWXWNvztgH3926hk9DA8kCBr" }
      it { should be_valid }
    end
  end


end
