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
@coll = db['bcc']
@mem = Mymem.new
def query_list(page)


  records = (page.css('span#body_body_myNewsList_upList div')).css('div.ls10')
  records.each{|r|
    url = "http://www.bcc.com.tw/" + r.to_s.scan(/href=\"(newsView[^\"]+)/)[0][0]
    date = r.css('div.dat').text
    
    if @mem.checkmem(url)
      #if we alreay crawled this data skip it!
      next
    else
      #do not thing continue crawl it!
    end

    phtml = Nokogiri::HTML(open(url))
    title = phtml.css('div.tt26').text
    category = phtml.css('div.gd3').to_s.scan /\s*([^<>]+)\s*<\/div>/
    category = (category[0][0]).gsub('&gt;','').gsub(/(^\s+|\s+$)/,'')
    body = phtml.css('div.ma7').to_s.scan /id=\"iclickAdBody_Start\"><\/span>\s*([\w\W]+?)\s*<span/
    body = body[0][0]

    json_rest = { :title => title,
                  :url => url,
                  :date => date,
                  :category => category,
                  :body => body         
                }
    begin
      @coll.insert(json_rest)
      #set up new key
      @mem.setkey(url)
    rescue Mongo::OperationFailure
      #puts "alreay have this news #{url}"
    end
    #puts JSON.generate(json_rest)
  }
end


encoded_url = URI.encode("http://www.bcc.com.tw/newsList.總覽")
safeurl = URI.parse(encoded_url)

page = Nokogiri::HTML(open(safeurl))
query_list(page)
