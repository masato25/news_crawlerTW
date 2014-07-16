require 'nokogiri'
require 'uri'
require 'open-uri'
require 'json'
require 'mongo'
require '../lib/mem'
require '../lib/load_conf'
include Mongo

@mod = load_config_file('../conf/myconf.conf')
db = MongoClient.new(@mod::MONGODB_HOST, @mod::MONGODB_PORT).db(@mod::MONGODB_DBNAME)
auth = db.authenticate(@mod::MONGODB_ACCOUNT , @mod::MONGODB_PASSWD)
@coll = db['appledaily']
@mem = Mymem.new

def query_list(page)
  step1 = page.search('.rtddd')
  step2 = step1.css('a')

  for div in step2
    title = div.css('h1').text
    url = (div.to_s.scan /href="([^"]+)"/)[0][0]
    date = (url.scan /\/.+?\/.+?\/(\d{8})/)[0][0] + " " + div.css('time').text
    category = div.css('h2').text
    url = "http://www.appledaily.com.tw" + url

    if @mem.checkmem(url)
      #if we alreay crawled this data skip it!
      next
    else
      #do not thing continue crawl it!
    end

    phtml = Nokogiri::HTML(open(url))
    body = phtml.css('p#summary').text
    json_rest = {   :title => title,
                    :url => url,
                    :date => date,
                    :category => category,    
                    :body => body    
                  }
    begin
       @coll.insert(json_rest)
       @mem.setkey(url) 
    rescue Mongo::OperationFailure
       #puts "alreay have this news"
       #@mem.setkey(url)
    end
    #puts JSON.generate(json_rest)
  end
end


encoded_url = URI.encode("http://www.appledaily.com.tw/realtimenews/section/new/1")
safeurl = URI.parse(encoded_url)

page = Nokogiri::HTML(open(safeurl))
query_list(page)
