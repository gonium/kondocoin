class VoucherController < ApplicationController

  attr_accessor :btc_address, 
    :code1, :code2, :code3, :code4, :code5, :code6

  # claiming the bitcoins in here!
  def index

  end

  def redeem
    # TODO: Compose voucher code, search in DB.
    code = "#{params[:voucher][:code1]}-"
    code += "#{params[:voucher][:code2]}-"
    code += "#{params[:voucher][:code3]}-"
    code += "#{params[:voucher][:code4]}-"
    code += "#{params[:voucher][:code5]}-"
    code += "#{params[:voucher][:code6]}"
    voucher = Voucher.find_by_code(code);
    if voucher && params[:voucher][:btc_address]
      # Attempt to create payout 
      #flash[:success] = 'You ' 
      render 'redeem'
    else
      flash[:error] = 'Invalid code.'
      render 'index'
    end
  end

end
