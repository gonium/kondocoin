require 'spec_helper'
require 'voucher_tools'

describe Voucher do

  before do
    @voucher = Voucher.new(
              code: "54ec-3a80-9b49-db78-7f5b-df6f",
              eurovalue: 1.8);
    @v_factory = VoucherFactory.new();
  end

  subject {@voucher}

  it { should respond_to(:code) }
  it { should respond_to(:eurovalue) }
  it { should respond_to(:state) }

  describe "code" do
    it "must be unique" do
      v1 = @v_factory.create_code;
      v2 = @v_factory.create_code;
      expect(v1).not_to eq(v2)
    end
    it "must be well-formed" do
      code = @v_factory.create_code;
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
  end

end
