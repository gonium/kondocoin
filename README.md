### About

The Kondocoin is a friendly bitcoin vending machine for bitcoin
newcomers. It allows you to sell vouchers for BTC: You generate a
voucher for a given fiat currency value and sell it using any kind of
vending machine. The customer then can enter the voucher's code on your
website and get his BTC. The amount of BTC to be paid is calculated
using the Bitstamp exchange rate (and the daily ECB Euro/Dollar conversion
rate). This has the advantage that the payout value is fair for
everyone: a pre-calculated bitcoin voucher might be worth a lot more (or
less) when it is purchased. A disadvantage is that the customer has to
trust the seller. For the very low amounts of BTC we're currently
handling this should be acceptable. We're also accepting only fixed
amounts of fiat currency, currently 2 Euro.

/Please: Consider running one in your hackerspace, promote the idea of
a decentralized currency!/

This repository contains a Rails 4 application for handling the website part.
The corresponding hardware is described in [the
wiki](https://github.com/gonium/kondocoin/wiki/hardware).
Yes, this is an old condom vending machine. I've got it for approx. 60
Euro on ebay. As it turns out, you can also buy the little cardboard
boxes that go into it on ebay. The setup has the advantage that it
doesn't need any power, is robust and can also be mounted outdoors.

The system doesn't require any customer data except for his wallet id.
This allows people to purchase a small amount of BTC anonymously.  The basic operation of the software works like this:

  * Make sure to have a look at the  ``config/application.yml`` for
    setting the Euro value of the voucher, the bitcoind access parameter
    etc.
  * You generate vouchers using ``rake voucher:generate``.   
  * You print them: ``rake voucher:print``. The vouchers are now marked
    active within the database. Print the vouchers and put them into the
    vending machine.
  * A customer buys a voucher. 
  * He enters the voucher code along with his wallet address. The server
    marks the voucher for payout in the database. The value of the
    voucher in BTC is calculated on the basis of the last Bitstamp
    quote.
  * Every five minutes a cronjob processes the payouts and triggers the
    transfer. This part is handled by an instance of bitcoind. Make sure
    the instance's balance is sufficient to pay for all active
    vouchers!

You can see a live (and operational) version of this software here:

[https://kondoco.in/](https://kondoco.in/)

### Missing features

  * A warning email should be sent to the site operator when the funds
    are not sufficient for all vouchers.
  * Optional: a similar email for all payouts.

### WARNING

This software was carefully developed and tested. However, I cannot
guarantee that there are no security vulnerabilities included - and maybe you
introduce vulnerabilities by the way you're operating it. In the worst
case, someone might steal your bitcoins. Or the world might come to an
end. Or a lolcat dies. You have been warned.

### Installation

```` 
 $ rvm use 2.0.0@kondocoin --create
 $ gem install rails
 $ bundle install # --without production (if you're just developing)
 $ bundle update
 $ bundle install
````
If the app complains about a missing database.yml, please generate a
dummy rails environment and copy the default database.yml from it. The
cronjobs can be installed using ``whenever -i``

Most of the functionality is only available through rake. Please run

````
 $ rake -T
````

to see a list of available tasks.

### Deployment

#### Install bitcoind
See also: https://bitcointalk.org/index.php?topic=1315.0
Install prerequisites.

    # sudo apt-get install build-essential libboost-all-dev \
      libssl-dev libdb-dev libglib2.0-dev libdb5.1++-dev \
      libminiupnpc-dev
    
Create a user 'bitcoind'.

    # adduser --system --disabled-login bitcoind

Clone and compile:

    # cd /home/bitcoind
    # git clone https://github.com/bitcoin/bitcoin.git
    # cd bitcoin/src
    # make -f makefile.unix bitcoind
    # mkdir ~/bin
    # cp bitcoind ~/bin

Configure bitcoind:

    $ vim /home/bitcoind/.bitcoin/bitcoin.conf
    rpcuser=bitcoinrpc
    rpcpassword=5J9QmVr35jTp9ej768ti926Yr27hhfcuF63ZhTsmorRN
    alertnotify=echo %s | mail -s "Bitcoin Alert" root@localhost

Create startup and log facitilies (using the daemontools)

    $ apt-get install daemontools daemontools-run

    $ mkdir /etc/service/bitcoind
    $ cat <<__EOF__ > /etc/service/bitcoind/run
    #!/bin/sh
    exec setuidgid bitcoind /home/bitcoind/bin/bitcoind 2>&1 
    __EOF__
    $ chmod 1755 /etc/service/bitcoind
    $ chmod +x /etc/service/bitcoind/run

    $ mkdir /etc/service/bitcoind/log
    $ cat <<__EOF__ > /etc/service/bitcoind/log/run
    #!/bin/sh
    exec multilog t /var/log/bitcoind
    __EOF__
    $ chmod +x /etc/service/bitcoind/log/run
    $ mkdir -p /var/log/bitcoind

TODO: This needs more debugging. for now, the bitcoind runs in a tmux.


### Installing the rails environment

Follow http://railscasts.com/episodes/335-deploying-to-a-vps

An nginx config file is available in the ``config`` subdirectory. I use
unicorn in my production environment - again, a suitable config file is
available in the ``config`` subdirectory.
