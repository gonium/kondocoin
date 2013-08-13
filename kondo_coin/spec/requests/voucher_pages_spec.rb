require 'spec_helper'
require 'voucher_tools'

describe "VoucherPages" do
  before do
    @v_factory = VoucherFactory.new();
  end

  let(:basetitle) { "Kondoco.in" }
  let(:btc_payout_address) { "fjiwerjiowejfiwjefijweio" }
  subject { page }

  describe "redeem voucher" do
    before { visit voucher_index_path }

    describe "page" do
      it { should have_content('Redeem') }
      it { should have_title(("#{basetitle} | Redeem")) }
    end

    describe "with invalid information" do
      before {click_button "Claim now" }
      it { should have_content('Invalid code') }
    end

    describe "with correct information" do
      before do
        @v_factory.create(1)
        voucher = Voucher.last
        codesections = voucher.code.split("-");
        fill_in "voucher_code1", with: codesections[0];
        fill_in "voucher_code2", with: codesections[1];
        fill_in "voucher_code3", with: codesections[2];
        fill_in "voucher_code4", with: codesections[3];
        fill_in "voucher_code5", with: codesections[4];
        fill_in "voucher_code6", with: codesections[5];
        fill_in "voucher_btc_address", with: :btc_payout_address;
        click_button "Claim now" 
      end
      it { should have_content('Success!') }
    end
  end

end
