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
@coll = db['stormmediagroup']
@mem = Mymem.new
@dic = Hash.new
@dic = {1 => "國內" , 2 => "國際" , 3 => "政治" , 4 => "兩岸"}

def query_list(page,c)
  step1 = page.css('div.function-div')
  items = step1.css('li.item')
  for body in items
    title = body.css('div.title').text
    url = (body.css('a.newsTitlelink').map{|l| (l['href'])})[0]
    url = "http://www.stormmediagroup.com" + url
    if @mem.checkmem(url)
      #if we alreay crawled this data skip it!
      next
    else
      #do not thing continue crawl it!
    end
    phtml = Nokogiri::HTML(open(url))
    pstep1 = phtml.css('div.mixRelatedNewsBlk')
    body = pstep1.css('div[class = "newsDescBlk mb20"]').text
    date = phtml.css('p.innerNewsInfo').to_s.scan /<\/a>\s*(.+)/
    date = date[0][0]
    category = @dic[c]
    json_rest = {   :title => title,
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
       #puts "alreay have this news"
       #@mem.setkey(url)
    end
    #puts JSON.generate(json_rest)
  end
end

for c in 1..4
  encoded_url = URI.encode("http://www.stormmediagroup.com/opencms/news/news-#{c}/more.html")
  safeurl = URI.parse(encoded_url)
  page = Nokogiri::HTML(open(safeurl))
  query_list(page,c)
end
