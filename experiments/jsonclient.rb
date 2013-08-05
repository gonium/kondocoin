require 'net/http'
require 'uri'
require 'json'
 
class BitcoinRPC
  def initialize(service_url)
    @uri = URI.parse(service_url)
  end
 
  def method_missing(name, *args)
    post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
    resp = JSON.parse( http_post_request(post_body) )
    raise JSONRPCError, resp['error'] if resp['error']
    resp['result']
  end
 
  def http_post_request(post_body)
    http    = Net::HTTP.new(@uri.host, @uri.port)
    request = Net::HTTP::Post.new(@uri.request_uri)
    request.basic_auth @uri.user, @uri.password
    request.content_type = 'application/json'
    request.body = post_body
    http.request(request).body
  end
 
  class JSONRPCError < RuntimeError; end
end
 
if $0 == __FILE__
  h = BitcoinRPC.new('http://bitcoinrpc:CkkS5LXxpJannkcFEybronYTdwyRos8ZgrwyMV92XTPk@127.0.0.1:8332')
  p h.getbalance
  p h.getinfo
  p h.getgenerate
  p h.getnewaddress
  p h.dumpprivkey( h.getnewaddress )
  p h.help
  # also see: https://en.bitcoin.it/wiki/Original_Bitcoin_client/API_Calls_list
end
