class VoucherController < ApplicationController

  #attr_accessor :btc_address, 
  #  :code1, :code2, :code3, :code4, :code5, :code6

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
    
    if voucher 
      # Attempt to create payout 
      #flash[:success] = 'You ' 
      session[:current_voucher_id] = voucher.id;
      #flash[:success] = session[:current_voucher_id]
      render 'payout'
    else
      flash[:error] = 'Invalid voucher code - please try again.'
      render 'index'
    end
  end

  def payout
    current_voucher = Voucher.find_by(session[:current_voucher_id]);
    wallet_id = params[:voucher][:btc_address]
    puts "Wallet: #{wallet_id}"
    if current_voucher.update_attributes(:wallet => wallet_id)
      puts "Voucher: #{current_voucher.id}"
      current_voucher.redeem!
      reset_session
      render success
    else
      flash[:error] = 'Invalid wallet address - please enter a correct one.'
      render 'payout'
    end
  end

  def success
  end

end
