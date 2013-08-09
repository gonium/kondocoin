class Voucher < ActiveRecord::Base
  #attr_protected :state
  # TODO: Use params(strong_parameters) to restrict access.
  
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
  state_machine :initial => :new do
    event :hardcopy do
      transition :new => :active
    end
    event :redeem do
      transition :active => :redeemed
    end
  end

end

class VoucherObserver < ActiveRecord::Observer
  # Callback for :ignite event *before* the transition is performed
  def before_ignite(voucher, transition)
    # log message
  end

  # Generic transition callback *after* the transition is performed
  def after_transition(voucher, transition)
    Audit.log(voucher, transition)
  end
end
