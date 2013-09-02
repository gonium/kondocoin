class VoucherController < ApplicationController
  def index
  end

  def redeem
    code = "#{params[:voucher][:code1]}-"
    code += "#{params[:voucher][:code2]}-"
    code += "#{params[:voucher][:code3]}-"
    code += "#{params[:voucher][:code4]}-"
    code += "#{params[:voucher][:code5]}-"
    code += "#{params[:voucher][:code6]}"
    voucher = Voucher.find_by_code(code);
    if voucher && voucher.active?
      # Attempt to create payout 
      session[:current_voucher_id] = voucher.id;
      @last_euro_ticker = Ticker.last.btc_eur
      @last_ticker_timestamp = Ticker.last.timestamp
      @current_btc_value = voucher.eurovalue / @last_euro_ticker;
      render :payout
    else
      flash.now[:error] = t("invalid_voucher_code")
      render :index
    end
  end

  def payout
    current_voucher = Voucher.find(session[:current_voucher_id]);
    wallet_id = params[:voucher][:btc_address]
    session[:current_wallet_id] = wallet_id
    @last_euro_ticker = Ticker.last.btc_eur
    @last_ticker_timestamp = Ticker.last.timestamp
    @current_btc_value = current_voucher.eurovalue / @last_euro_ticker;
    #if current_voucher.update_attributes({:wallet => wallet_id, :payout_value => @current_btc_value}) 
    payout = Payout.new(
                     wallet: wallet_id,
                     payout_value: @current_btc_value,
                     voucher_id: current_voucher.id);
    if payout.valid?
      current_voucher.redeem!
      current_voucher.save!
      payout.save!
      redirect_to :success
    else
      flash.now[:error] = t("invalid_wallet_id")
      render :payout
    end
  end

  def success
    @blockchain_link = "http://www.blockchain.info/address/#{session[:current_wallet_id]}"
    reset_session
  end

end
