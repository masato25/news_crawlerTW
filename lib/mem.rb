require 'memcached'

class Mymem
  def initialize(server="localhost:11211")
    @cache = Memcached.new(server)
  end
  def setkey(key)
    begin
      @cache.set key,0
    rescue => e
      puts e
    end
  end
  def checkmem(key)
    begin
      if @cache.get key
        return true
      else
        return false
      end
    rescue Memcached::NotFound
      return false
    rescue => e
      puts e
      return nil
    end
  end
end
#mm = Mymem.new
# test sample
#setkey('http://www.bcc.com.tw/newsView.2374213')
#p mm.checkmem('http://www.bcc.com.tw/newsView.2374198')
