class BitcoinClient
  def initialize
    CONFIG[:bitcoind_port] ||= 18332;
    CONFIG[:bitcoind_user] ||= "bitcoinrpc";
    CONFIG[:bitcoin_account_name] ||= "default";
    @client = Bitcoin::Client.new(CONFIG[:bitcoind_user], CONFIG[:bitcoind_secret])
    @client.port = CONFIG[:bitcoind_port]
    @client.setgenerate(false)
  end

  def create_address
    @client.getnewaddress(CONFIG[:bitcoin_account_name]);
  end

  def get_account_info
    info = <<-"EOAI"
    The balance of the account #{CONFIG[:bitcoin_account_name]} is BTC #{@client.getbalance(CONFIG[:bitcoin_account_name])}
    The balance of the default account is BTC #{@client.getbalance()}
    EOAI
  end

  def list_addresses
    info = <<-"EOAI"
    Account #{CONFIG[:bitcoin_account_name]} uses the addresses
    EOAI
    addresses = @client.getaddressesbyaccount(CONFIG[:bitcoin_account_name]);
    addresses.each{|addr|
      info += "    * #{addr}\r\n"
    }
    return info
  end

  def is_valid_wallet?(addr)
    return @client.validateaddress(addr)["isvalid"]
  end

  def get_transaction_info(txid)
    return @client.gettransaction(txid)
  end

  def transfer_to(wallet_id, amount)
    if is_valid_wallet?(wallet_id)
      puts "Sending #{amount} to #{wallet_id}"
      #transaction_id = @client.sendtoaddress(wallet_id, amount.to_f);
      transaction_id = @client.sendfrom(CONFIG[:bitcoin_account_name], wallet_id, amount.to_f);
      return transaction_id
    else
      raise StandardError("Invalid wallet address")
    end
  end

  def process_pending_payouts
    pending_vouchers = Voucher.with_state(:redeemed);
    pending_vouchers.each{|voucher|
      payout = Payout.find_by(voucher_id: voucher.id);
      puts "Processing payout for voucher #{voucher.id}: Transfer BTC #{payout.payout_value} to address #{payout.wallet}"
      begin
        transaction_id = transfer_to(payout.wallet, payout.payout_value);
        puts "Transferred funds, transaction id is #{transaction_id}"
        voucher.payout!
      rescue StandardError => e
        puts "Failed to transfer funds: #{e}"
      end
    }
  end

end
