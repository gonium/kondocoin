require 'voucher_tools'

num_vouchers = 10;
eurovalue_default = 1.7;
namespace :voucher do
  desc "Create a new set of vouchers in the database."
  task generate: :environment do
    puts "Generating #{num_vouchers} vouchers."
    code_factory = CodeFactory.new();
    num_vouchers.times{|i|
      current_code = code_factory.create
      v=Voucher.create(code: current_code,
              eurovalue: eurovalue_default);
    }
  end
end


