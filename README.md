### Installation

```` 
 $ rvm use 2.0.0@kondocoin --create
 $ gem install rails
 $ bundle install --without production
 $ bundle update
 $ bundle install
````
If the app complains about a missing database.yml, please generate a
dummy rails environment and copy the default database.yml from it.


###

 * [Bitcoind JSON-RPC API](https://en.bitcoin.it/wiki/API_reference_(JSON-RPC)#Ruby)
 * https://github.com/bkerley/bitcoind
 * PDF: http://railscasts.com/episodes/78-generating-pdf-documents
   * http://blog.idyllic-software.com/blog/bid/204082/Creating-PDF-using-Prawn-in-Ruby-on-Rails
 * http://railscasts.com/episodes/342-migrating-to-postgresql
 * Statemachine: https://github.com/pluginaweek/state_machine
   * siehe "Web Frameworks" fuer ein Beispiel
 * Cronjob: Hält Bitcoin-Kurs aktuell.
   * siehe (veraltet) http://railscasts.com/episodes/164-cron-in-ruby?autoplay=true
   * https://github.com/javan/whenever
 * Kursdaten abrufen:
   * http://stackoverflow.com/questions/3139879/how-do-i-get-currency-exchange-rates-using-google-finance-api

 * Autotab for entering the code:
   * http://www.mathachew.com/sandbox/jquery-autotab/

 * Icon fonts:
   * http://t3n.de/news/10-kostenlose-icon-fonts-450651/?utm_source=feedburner+t3n+News+12.000er&utm_medium=feed&utm_campaign=Feed%3A+aktuell%2Ffeeds%2Frss+%28t3n+News%29
 * Flat UI for Rails:
   * http://designmodo.com/flat/
   * https://github.com/darthdeus/flat-ui-rails
   * https://github.com/reflection/designmodo-flatuipro-rails
   * http://stackoverflow.com/questions/17173133/how-can-i-add-the-flat-ui-into-rails
   * https://github.com/pkurek/flatui-rails
 * I18N:
   * http://thepugautomatic.com/2012/07/rails-i18n-tips/



 ruby bitcoin-client gem


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
