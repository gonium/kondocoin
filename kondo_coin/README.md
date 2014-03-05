### Notes

Currently, there is a bug in the bitstamp gem (v0.3.0). The issue is
described here:

    https://github.com/kojnapp/bitstamp/pull/9

I simply patched my gem files (somewhere in ~/.rvm/...) to accomodate
for the vwap change.

### Testing the application

The application can be tested by using the bitcoin testnet. You need to
create an account for the application

TODO: How. Use bitcoind client.getnewaddress(accountname) foo.

and add some bitcoins to it. Easiest is using a testnet faucet, i.e.

 * http://testnet.mojocoin.com/
 * http://tpfaucet.appspot.com/

The latter also provides random accounts for testing purposes.
