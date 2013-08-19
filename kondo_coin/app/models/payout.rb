class Payout < ActiveRecord::Base
  belongs_to :voucher
  validates :voucher_id, 
    presence: true,
    uniqueness: true

  validates :wallet, 
    presence: true,
    format: {
      #:with => /\A[13n][1-9A-Za-z][^OIl]{20,40}\z/, # doesn't match testnet addresses
      :with => /\A[13mn][1-9A-Za-z][^OIl]{20,40}\z/,
      :message => "Voucher has invalid wallet address format"
    },
    :allow_blank => false

  validates :payout_value, 
    presence: true,
    :numericality => {
      :greater_than_or_equal_to => 0.0,
      :message => "Payout value must be non-negative than zero",
      :allow_nil => false
    }
end
