require 'securerandom'

class CodeFactory
  def create
    a = [];
    6.times { a << SecureRandom.hex(2)};
    return a.join("-").downcase;
  end
end

