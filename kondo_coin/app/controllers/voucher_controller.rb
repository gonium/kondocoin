class VoucherController < ApplicationController

  attr_accessor :btc_address, :code1, :code2, :code3, :code4

  # claiming the bitcoins in here!
  def index

  end

  def redeem
    # TODO: Compose voucher code, search in DB.
    #@voucher = Voucher.find(params[:id]) || Voucher.new
  end

end
