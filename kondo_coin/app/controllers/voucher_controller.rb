require 'pp'

class VoucherController < ApplicationController
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

    # store voucher id in session
    # see http://guides.rubyonrails.org/action_controller_overview.html#session
    
    if voucher && voucher.active?
      # Attempt to create payout 
      session[:current_voucher_id] = voucher.id;
      @last_euro_ticker = Ticker.last.btc_eur
      @last_ticker_timestamp = Ticker.last.timestamp
      @current_btc_value = voucher.eurovalue / @last_euro_ticker;
      render :payout
    else
      flash.now[:error] = 'Invalid voucher code - please try again.'
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
    #pp current_voucher
    if payout.valid?
      current_voucher.redeem!
      current_voucher.save!
      payout.save!
      redirect_to :success
    else
      flash.now[:error] = 'Invalid wallet address - please enter a correct one.'
      render :payout
    end
  end

  def success
    @blockchain_link = "http://www.blockchain.info/address/#{session[:current_wallet_id]}"
    reset_session
  end

end
