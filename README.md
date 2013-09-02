### About

The Kondocoin is a friendly bitcoin vending machine for bitcoin
newcomers. It allows you to sell vouchers for BTC: You generate a
voucher for a given fiat currency value and sell it using any kind of
vending machine. The customer then can enter the voucher's code on your
website and get his BTC. This repository contains a Rails 4 application
for handling the website part.

The basic operation works like this:

  * You generate vouchers using ``rake voucher:generate``.
  * You print them: ``rake voucher:print``. The vouchers are now marked
    active within the database.
  * A customer buys a voucher. 
  * He enters the voucher code along with his wallet address. The server
    running this software accesses an instance of bitcoind to transfer
    the funds.

TODO: More detailed description of the operation.

You can see a live (and operational) version of this software here:

    https://kondoco.in/

### WARNING

This software was carefully developed and tested. However, I cannot
guarantee that there are no security vulnerabilities included - and maybe you
introduce vulnerabilities by the way you're operating it. In the worst
case, someone might steal your bitcoins. You have been warned.

### Development Installation

```` 
 $ rvm use 2.0.0@kondocoin --create
 $ gem install rails
 $ bundle install --without production
 $ bundle update
 $ bundle install
````
If the app complains about a missing database.yml, please generate a
dummy rails environment and copy the default database.yml from it.

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
