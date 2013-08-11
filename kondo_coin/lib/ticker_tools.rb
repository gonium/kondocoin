require 'xmlsimple'
require 'open-uri'
require 'bitstamp'

class CurrencyConverter
  
  def initialize
    @ecb_url = "http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"
  end

  def usd2eur(usd_quote)
    doc = XmlSimple.xml_in(open(@ecb_url))
    level1 = doc["Cube"][0]
    level1["Cube"][0]["Cube"].each {| entry |
      if entry["currency"] == "USD"
        #puts entry["rate"] 
        return usd_quote/entry["rate"].to_f
      end
    }
    # Quote for USD not found - raise exception.
    raise 'Cannot extract USD quote from ECB dataset.'
  end

end

class BitstampMarket

  def quote
    return Bitstamp.ticker.last.to_f
  end

end


if __FILE__ == $0
  c=CurrencyConverter.new
  b=BitstampMarket.new
  q=b.quote;
  puts "100 USD are #{c.usd2eur(100)} EUR"
  puts "1 BTC is #{q} USD and #{c.usd2eur(q)} EUR"
end
