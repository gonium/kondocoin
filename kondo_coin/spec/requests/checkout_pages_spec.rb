require 'spec_helper'

describe "CheckoutPages" do

  let(:basetitle) { "Kondoco.in" }
  subject { page }

  describe "redeem page" do
    before { visit checkout_redeem_path }

    it { should have_content('redeem') }
    it { should have_title(("#{basetitle} | Redeem")) }
  end

end
