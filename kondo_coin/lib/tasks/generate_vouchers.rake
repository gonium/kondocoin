namespace :db do
  desc "Create a new set of vouchers in the database."
  task gen_vouchers: :environment do
    puts "Generating vouchers."
  end
end
