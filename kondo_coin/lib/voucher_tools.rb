require 'securerandom'

class CodeFactory
  def create
    a = [];
    6.times { a << SecureRandom.hex(2)};
    return a.join("-").downcase;
  end
end

class VoucherFactory
  def initialize
    @code_factory = CodeFactory.new();
    CONFIG[:voucher_count] ||= 10;
    CONFIG[:voucher_eurovalue] ||= 1.8;
  end
  def create(num = CONFIG[:voucher_count])
    num.times{|i|
      current_code = @code_factory.create
      v=Voucher.create(code: current_code,
              eurovalue: CONFIG[:voucher_eurovalue]);
    }
  end
end

class VoucherDocument < Prawn::Document
  def initialize(vouchers) 
    super(
          top_margin: 70,
          page_size: "A4",
          page_layout: :landscape
         )
    @vouchers = vouchers
    template_file = Rails.root.join('app', 'assets', 
                                    'pdfs', CONFIG[:voucher_templatefile])
    vouchers.each{|voucher|
      start_new_page(:template => template_file)
      gen_voucher(voucher)
      # Mark the voucher as printed in the database.
      voucher.hardcopy!
    }
  end

  def gen_voucher(voucher)
    render_code(voucher)
    render_eurovalue(voucher)
    render_support_text(voucher)
  end

  def render_code(voucher)
    font("Courier") do
      text_box "#{voucher.code}",
        :at => [60, 275],
        :height => 100,
        :width => 800,
        size: 36, 
        style: :bold
    end
  end

  def render_eurovalue(voucher)
    font("Courier") do
      text_box "EUR\n#{'%2.2f' % voucher.eurovalue}",
        :at => [620, 180],
        :height => 100,
        :width => 500,
        size: 36, 
        style: :bold
    end
  end



  def render_support_text(voucher)
    font("Courier") do
      text_box "Voucher No. #{voucher.id}",
        :at => [620, 15],
        :height => 100,
        :width => 200,
        size: 12, 
        style: :normal
    end
  end
end
