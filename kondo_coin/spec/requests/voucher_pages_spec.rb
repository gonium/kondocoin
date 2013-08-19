require 'spec_helper'
require 'voucher_tools'
require 'pp'

describe "VoucherPages" do
  before do
    @v_factory = VoucherFactory.new();
    # put a faked ticker value into the database
    t=Ticker.create(btc_usd: 2.34,
                    btc_eur: 3.32,
                    timestamp: DateTime.now
                   );
  end

  let(:basetitle) { "Kondoco.in" }
  let(:btc_invalid_payout_address) { "XXXfio" }
  let(:btc_valid_payout_address) { "1HGXxsFArRRWXWNvztgH3926hk9DA8kCBr" }

  let(:voucher) do
    @v_factory.create(1)
    voucher = Voucher.last
    voucher.hardcopy! # simulate printing of our voucher.
    return voucher
  end

  let(:another_voucher) do
    @v_factory.create(1)
    another_voucher = Voucher.last
    another_voucher.hardcopy! # simulate printing of our voucher.
    return another_voucher
  end

  subject { page }

  describe "enter voucher" do
    before { visit redeem_path }

    describe "page" do
      it { should have_content('Redeem') }
      it { should have_title(("#{basetitle} | Redeem")) }
    end

    describe "with invalid information" do
      before {click_button "Verify voucher now" }
      it { should have_content('Invalid voucher code') }
    end

    describe "with correct voucher code" do
      before do
        codesections = voucher.code.split("-");
        fill_in "voucher_code1", with: codesections[0];
        fill_in "voucher_code2", with: codesections[1];
        fill_in "voucher_code3", with: codesections[2];
        fill_in "voucher_code4", with: codesections[3];
        fill_in "voucher_code5", with: codesections[4];
        fill_in "voucher_code6", with: codesections[5];
        click_button "Verify voucher now" 
      end
      it { should have_content('Code accepted!') }
      it "must remain in the active state" do
        expect(voucher).to be_active
      end
    end
  end

  describe "enter wallet" do
    before { visit redeem_path }

    describe "without any wallet payout address" do
      before do
        codesections = voucher.code.split("-");
        fill_in "voucher_code1", with: codesections[0];
        fill_in "voucher_code2", with: codesections[1];
        fill_in "voucher_code3", with: codesections[2];
        fill_in "voucher_code4", with: codesections[3];
        fill_in "voucher_code5", with: codesections[4];
        fill_in "voucher_code6", with: codesections[5];
        click_button "Verify voucher now" 
        click_button "Claim now" 
      end

      describe "page" do
        it { should have_content('Code accepted!') }
        it { should have_content('Invalid wallet address') }
        it { should have_title(("#{basetitle} | Redeem")) }
      end

      describe "voucher" do
        it "must remain in the active state" do
          expect(voucher).to be_active
        end
      end
    end


    describe "with invalid wallet payout address" do
      before do
        codesections = voucher.code.split("-");
        fill_in "voucher_code1", with: codesections[0];
        fill_in "voucher_code2", with: codesections[1];
        fill_in "voucher_code3", with: codesections[2];
        fill_in "voucher_code4", with: codesections[3];
        fill_in "voucher_code5", with: codesections[4];
        fill_in "voucher_code6", with: codesections[5];
        click_button "Verify voucher now" 
        fill_in "voucher_btc_address", with: btc_invalid_payout_address
        click_button "Claim now" 
      end

      describe "page" do
        it { should have_content('Code accepted!') }
        it { should have_content('Invalid wallet address') }
        it { should have_title(("#{basetitle} | Redeem")) }
      end

      describe "voucher" do
        it "must remain in the active state" do
          expect(voucher).to be_active
        end
      end
    end

    describe "with valid wallet payout address" do
      before do
        codesections = voucher.code.split("-");
        fill_in "voucher_code1", with: codesections[0];
        fill_in "voucher_code2", with: codesections[1];
        fill_in "voucher_code3", with: codesections[2];
        fill_in "voucher_code4", with: codesections[3];
        fill_in "voucher_code5", with: codesections[4];
        fill_in "voucher_code6", with: codesections[5];
        click_button "Verify voucher now" 
        fill_in "voucher_btc_address", with: btc_valid_payout_address
        click_button "Claim now" 
      end

      describe "page" do
        it { should have_content('Success') }
        it { should_not have_content('Invalid wallet address') }
        it { should have_title(("#{basetitle} | Redeem")) }
      end

      describe "voucher" do
        it "must be in the redeemed state" do
          db_voucher = Voucher.find(voucher.id);
          expect(db_voucher).to be_redeemed
        end
      end

      describe "another voucher to the same address" do
        before do
          visit redeem_path
          codesections = another_voucher.code.split("-");
          fill_in "voucher_code1", with: codesections[0];
          fill_in "voucher_code2", with: codesections[1];
          fill_in "voucher_code3", with: codesections[2];
          fill_in "voucher_code4", with: codesections[3];
          fill_in "voucher_code5", with: codesections[4];
          fill_in "voucher_code6", with: codesections[5];
          click_button "Verify voucher now" 
          fill_in "voucher_btc_address", with: btc_valid_payout_address
          click_button "Claim now" 
        end

        describe "page" do
          it { should have_content('Success') }
          it { should have_link("Blockchain Wallet Transactions", href:  "http://www.blockchain.info/address/#{btc_valid_payout_address}"
) }
          it { should_not have_content('Invalid wallet address') }
          it { should have_title(("#{basetitle} | Redeem")) }
        end

        describe "voucher" do
          it "must be in the redeemed state" do
            db_voucher = Voucher.find(voucher.id);
            expect(db_voucher).to be_redeemed
          end
          it "must have a payout entry" do
            payout = Payout.find_by(voucher_id: voucher.id);
            expect(payout.payout_value).not_to be_nil
            expect(payout.wallet).to eq(btc_valid_payout_address)
          end
        end
      end

      describe "the same voucher twice" do
        before do
          visit redeem_path
          codesections = voucher.code.split("-");
          fill_in "voucher_code1", with: codesections[0];
          fill_in "voucher_code2", with: codesections[1];
          fill_in "voucher_code3", with: codesections[2];
          fill_in "voucher_code4", with: codesections[3];
          fill_in "voucher_code5", with: codesections[4];
          fill_in "voucher_code6", with: codesections[5];
          click_button "Verify voucher now" 
        end

        describe "page" do
          it { should have_content('Invalid voucher code') }
          it { should_not have_content('Invalid wallet address') }
          it { should have_title(("#{basetitle} | Redeem")) }
        end

        describe "voucher" do
          it "must remain in the redeemed state" do
            db_voucher = Voucher.find(voucher.id);
            expect(db_voucher).to be_redeemed
          end
        end
      end


    end

  end
end
