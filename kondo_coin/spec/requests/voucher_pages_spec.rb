require 'spec_helper'
require 'voucher_tools'

describe "VoucherPages" do
  before do
    @v_factory = VoucherFactory.new();
    @v_factory.create(1)
    @voucher = Voucher.last
    @voucher.hardcopy! # simulate printing of our voucher.
    @codesections = @voucher.code.split("-");
  end

  let(:basetitle) { "Kondoco.in" }
  let(:btc_invalid_payout_address) { "fjiwerjiowejfiwjefijweio" }
  let(:btc_valid_payout_address) { "1HGXxsFArRRWXWNvztgH3926hk9DA8kCBr" }
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
        fill_in "voucher_code1", with: @codesections[0];
        fill_in "voucher_code2", with: @codesections[1];
        fill_in "voucher_code3", with: @codesections[2];
        fill_in "voucher_code4", with: @codesections[3];
        fill_in "voucher_code5", with: @codesections[4];
        fill_in "voucher_code6", with: @codesections[5];
        click_button "Verify voucher now" 
      end
      it { should have_content('code has been accepted') }
      it "must remain in the active state" do
        expect(@voucher).to be_active
      end
    end
  end

  describe "enter wallet" do
    before { visit redeem_path }
    describe "with invalid wallet payout address" do
      before do
        codesections = @voucher.code.split("-");
        fill_in "voucher_code1", with: @codesections[0];
        fill_in "voucher_code2", with: @codesections[1];
        fill_in "voucher_code3", with: @codesections[2];
        fill_in "voucher_code4", with: @codesections[3];
        fill_in "voucher_code5", with: @codesections[4];
        fill_in "voucher_code6", with: @codesections[5];
        click_button "Verify voucher now" 
        fill_in "voucher_btc_address", with: :btc_invalid_payout_address
        click_button "Claim now" 
      end

      describe "page" do
        it { should have_content('voucher code has been accepted') }
        it { should have_content('Invalid wallet address') }
        it { should have_title(("#{basetitle} | Redeem")) }
      end

      describe "voucher" do
        it "must remain in the active state" do
          expect(@voucher).to be_active
        end
      end
    end

  end


end
