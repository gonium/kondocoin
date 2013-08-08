require 'securerandom'

class VoucherFactory
  def create_code
    a = [];
    6.times { a << SecureRandom.hex(2)};
    return a.join("-").downcase;
  end
end

