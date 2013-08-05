require 'bitcoin'
client = Bitcoin::Client.new('bitcoinrpc', 'CkkS5LXxpJannkcFEybronYTdwyRos8ZgrwyMV92XTPk')
p client.balance
