require 'voucher_tools'
require 'bitcoin-tools'

namespace :voucher do
  desc "Create a new set of vouchers in the database."
  task generate: :environment do
    puts "Generating new vouchers."
    v_factory = VoucherFactory.new()
    v_factory.create()
  end
end

namespace :voucher do
  desc "Print all 'new' vouchers from the database & update them."
  task print: :environment do
    puts "Preparing PDF for new vouchers."
    new_vouchers = Voucher.with_state(:new);
    fail "No new vouchers found - use voucher:generate to create new ones." if new_vouchers.count == 0
    doc = VoucherDocument.new(new_vouchers);
    doc.render_file("voucher.pdf");  
  end
end

namespace :voucher do
  desc "Everything in a glance."
  task overview: :environment do
    puts "Overview:"
    active = Voucher.with_state(:active);
    active_eurovalue = 0.0
    active.each{|v|
      active_eurovalue += v.eurovalue;
    }
    redeemed = Voucher.with_state(:redeemed);
    redeemed_eurovalue = 0.0
    redeemed_btcvalue = 0.0
    redeemed.each{|v|
      p=Payout.find_by(voucher_id: v.id);
      redeemed_eurovalue += v.eurovalue; 
      redeemed_btcvalue += p.payout_value; 
    }
    completed = Voucher.with_state(:completed);
    completed_eurovalue = 0.0
    completed_btcvalue = 0.0
    completed.each{|v|
      p=Payout.find_by(voucher_id: v.id);
      completed_eurovalue += v.eurovalue; 
      completed_btcvalue += p.payout_value; 
    }
    last_tick = Ticker.last(1)[0]
    puts "Ticker: #{last_tick.timestamp} - USD #{last_tick.btc_usd}, EUR #{last_tick.btc_eur}"
    begin
      client=BitcoinClient.new();
      puts client.get_account_info();
    rescue
      puts "Error - cannot get current bitcoin wallet balance. bitcoind down?"
    end
    puts "Active:\t\t#{active.count} vouchers, #{active_eurovalue} Euro in total";
    puts "Redeemed:\t#{redeemed.count} vouchers, #{redeemed_eurovalue} Euro / #{redeemed_btcvalue} BTC in total";
    puts "Completed:\t#{completed.count} vouchers, #{completed_eurovalue} Euro / #{completed_btcvalue} BTC in total";

  end
end

namespace :voucher do
  desc "Show all active vouchers from the database."
  task active: :environment do
    puts "active vouchers:"
    active = Voucher.with_state(:active);
    fail "No active vouchers found." if active.count == 0
    active.each{|v|
      puts "ID #{v.id}, eurovalue #{v.eurovalue}, code #{v.code}"
    }
  end
end

namespace :voucher do
  desc "Show all redeemed vouchers from the database."
  task redeemed: :environment do
    puts "Redeemed vouchers:"
    redeemed = Voucher.with_state(:redeemed);
    fail "No redeemed vouchers found." if redeemed.count == 0
    redeemed.each{|v|
      p=Payout.find_by(voucher_id: v.id);
      puts "ID #{v.id}, eurovalue #{v.eurovalue}, btcvalue #{p.payout_value}, to be paid to #{p.wallet}"
    }
  end
end

namespace :voucher do
  desc "Show all completed payouts from the database."
  task completed: :environment do
    completed = Voucher.with_state(:completed);
    if completed.count == 0
      puts "No completed vouchers found." 
    else 
      puts "Completed vouchers:"
      completed.each{|v|
        p=Payout.find_by(voucher_id: v.id);
        puts "ID #{v.id}, eurovalue #{v.eurovalue}, btcvalue #{p.payout_value}, paid to #{p.wallet}"
      }
    end
  end
end

namespace :voucher do
  desc "send pending payouts"
  task :payout => :environment do 
    client=BitcoinClient.new();
    client.process_pending_payouts
  end
end

