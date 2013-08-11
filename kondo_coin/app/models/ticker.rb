class Ticker < ActiveRecord::Base
  validates :btc_usd, 
    presence: true,
    :numericality => {
      :greater_than => 0.0,
      :message => "BTC-USD value must be greater than zero"
    }
  validates :btc_eur, 
    presence: true,
    :numericality => {
      :greater_than => 0.0,
      :message => "BTC-EUR value must be greater than zero"
    }
  validates :timestamp,
    presence: true



end
