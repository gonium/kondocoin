require 'spec_helper'
require 'voucher_tools'

describe Voucher do

  before do
    @voucher = Voucher.new(
              code: "54ec-3a80-9b49-db78-7f5b-df6f",
              eurovalue: 1.8);
    @c_factory = CodeFactory.new();
    @v_factory = VoucherFactory.new();
  end

  subject {@voucher}

  it { should respond_to(:code) }
  it { should respond_to(:eurovalue) }
  it { should respond_to(:state) }

  describe "voucherfactory" do
    it "must generate right number of vouchers" do
      startcount = Voucher.count
      @v_factory.create(3)
      endcount = Voucher.count
    end
    it "must generate the default number of vouchers" do
      startcount = Voucher.count
      @v_factory.create()
      endcount = Voucher.count
      expect(endcount - startcount).to eq(CONFIG[:voucher_count])
    end
  end

  describe "PDF export" do
    it "must mark the exported vouchers as active" do
      @v_factory.create(1)
      expect( Voucher.with_state(:new).count ).to eq(1)
      doc=VoucherDocument.new(Voucher.with_state(:new));
      expect( Voucher.with_state(:new).count ).to eq(0)
      expect( Voucher.with_state(:active).count ).to eq(1)
    end
  end

  describe "code" do
    it "must be unique" do
      v1 = @c_factory.create;
      v2 = @c_factory.create;
      expect(v1).not_to eq(v2)
    end
    it "must be well-formed" do
      code = @c_factory.create;
      expect(code).to match(/^[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}$/)
    end
    describe "must be present" do
      before {@voucher.code = ""}
      it { should_not be_valid }
    end
    describe "when already taken" do
      before do
        identical_voucher = @voucher.dup
        identical_voucher.save
      end
      it { should_not be_valid }
    end

  end

  describe "eurovalue" do
    describe "must be present" do
      before {@voucher.eurovalue = nil}
      it { should_not be_valid }
    end
    describe "must be greater than zero" do
      before {@voucher.eurovalue = 0.0}
      it { should_not be_valid }
    end
  end

  describe "state" do
    it "must be initially 'new'" do
      @voucher.should be_new
    end
    it "becomes active when a hardcopy is created" do
      @voucher.should be_new
      @voucher.hardcopy!
      @voucher.should be_active
    end
    it "becomes redeemed after harcopy and redeem actions" do
      @voucher.should be_new
      @voucher.hardcopy!
      @voucher.redeem!
      @voucher.should be_redeemed
    end
    it "becomes completed after harcopy, redeem and payout actions" do
      @voucher.should be_new
      @voucher.hardcopy!
      @voucher.redeem!
      @voucher.payout!
      @voucher.should be_completed
    end
 
    it "cannot be reset after being redeemed" do
      @voucher.should be_new
      @voucher.hardcopy!
      @voucher.redeem!
      expect { @voucher.hardcopy! }.to raise_error
      @voucher.should be_redeemed
      @voucher.payout!
      expect { @voucher.payout! }.to raise_error
      expect { @voucher.hardcopy! }.to raise_error
      expect { @voucher.redeem! }.to raise_error
      @voucher.should be_completed
    end

  end

end
