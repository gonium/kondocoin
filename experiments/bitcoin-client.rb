require 'bitcoin'
client = Bitcoin::Client.new('bitcoinrpc', 'CkkS5LXxpJannkcFEybronYTdwyRos8ZgrwyMV92XTPk')

# see https://github.com/sinisterchipmunk/bitcoin-client/blob/master/lib/bitcoin/client.rb
#
p client.setgenerate(false)
p client.balance
p client.getinfo
accountname = "default_account"
# create new address
#p client.getnewaddress(accountname);
p client.listaccounts
p client.getaddressesbyaccount(accountname)
p client.getbalance(accountname)

experiment_address = "1HGXxsFArRRWXWNvztgH3926hk9DA8kCBr"
p client.listreceivedbyaccount()

p client.validateaddress(experiment_address)
if experiment_address =~ /^[13n][1-9A-Za-z][^OIl]{20,40}/
  puts "Sounds legit."
else
  puts "Invalid address."
end
