require 'bitcoin'
client = Bitcoin::Client.new('bitcoinrpc', '2QRWVifGJtcFP7t6GQ73T8tWoUZrNiMLNcxmuAsEuvCv')
client.port = 18332
#client = Bitcoin::Client.new('bitcoinrpc', 'CkkS5LXxpJannkcFEybronYTdwyRos8ZgrwyMV92XTPk')

# see https://github.com/sinisterchipmunk/bitcoin-client/blob/master/lib/bitcoin/client.rb
#
p client.setgenerate(false)
puts "Client balance: #{client.balance}"
puts "Client.getinfo: #{client.getinfo}"
accountname = "default_account"
# create new address, run only once.
#p client.getnewaddress(accountname);
puts "Accounts: #{client.listaccounts}"
puts "Account addresses: #{client.getaddressesbyaccount(accountname)}"
puts "Account balance: #{client.getbalance(accountname)}"

experiment_address = "1HGXxsFArRRWXWNvztgH3926hk9DA8kCBr"
p client.listreceivedbyaccount()

if client.validateaddress(experiment_address)["isvalid"]
  puts "Not a valid address"
else
  puts "Address is valid."
end

#if experiment_address =~ /^[13n][1-9A-Za-z][^OIl]{20,40}/
#  puts "Sounds legit."
#else
#  puts "Invalid address."
#end
