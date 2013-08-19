require 'bitcoin-tools'

namespace :bitcoin do
  desc "Get current fund balance."
  task balance: :environment do
    client=BitcoinClient.new();
    puts client.get_account_info();
  end
end

namespace :bitcoin do
  desc "Create default address."
  task mkaddress: :environment do
    client=BitcoinClient.new();
    puts client.create_address();
  end
end

namespace :bitcoin do
  desc "List addresses."
  task lsaddr: :environment do
    client=BitcoinClient.new();
    puts client.list_addresses();
  end
end

namespace :bitcoin do
  desc "Check if address is a valid bitcoin address. use: rake bitcoin:validate[<ID>]"
  task :validate, [:address] => :environment do |t, args|
    client=BitcoinClient.new();
    if client.is_valid_wallet?(args.address)
      puts "The address #{args.address} is valid"
    else
      puts "The address #{args.address} is invalid"
    end
  end
end

namespace :bitcoin do
  desc "Send BTC to address. use: rake bitcoin:send[<ID>,<amount>]"
  task :send, [:address, :amount] => :environment do |t, args|
    client=BitcoinClient.new();
    client.transfer_to(args.address, args.amount)
  end
end

namespace :bitcoin do
  desc "Get transaction details. Use: rake bitcoin:gettransaction[<TXID>]"
  task :gettransaction, [:txid] => :environment do |t, args|
    client=BitcoinClient.new();
    puts client.get_transaction_info(args.txid)
  end
end


