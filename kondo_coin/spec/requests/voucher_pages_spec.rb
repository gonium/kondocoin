require 'spec_helper'
require 'voucher_tools'

describe "VoucherPages" do
  before do
    @v_factory = VoucherFactory.new();
  end

  let(:basetitle) { "Kondoco.in" }
  subject { page }

  describe "redeem voucher" do
    let (:voucher) { @v_factory.create(1) }
    before { visit voucher_index_path }

    describe "page" do
      it { should have_content('Redeem') }
      it { should have_title(("#{basetitle} | Redeem")) }
    end

    describe "with invalid information" do
      before {click_button "Claim now" }
      it { should have_content('error') }
    end
  end

end
