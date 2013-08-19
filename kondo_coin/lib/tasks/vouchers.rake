require 'voucher_tools'

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



