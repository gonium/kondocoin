class Voucher < ActiveRecord::Base
  before_save { code.downcase! }

  validates :code, 
    presence: true,
    uniqueness: { case_sensitive: false},
    format: {
      :with => /\A[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}\z/,
      :message => "Voucher has invalid code format"
    }
  validates :eurovalue, 
    presence: true,
    :numericality => {
      :greater_than => 0.0,
      :message => "Voucher value must be greater than zero"
    }

  # See https://github.com/pluginaweek/state_machine for state machine
  # documentation.
    
end
