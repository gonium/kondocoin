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



