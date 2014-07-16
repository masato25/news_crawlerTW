#台灣新聞簡易小爬蟲
1. 請使用Ruby 2.0 以上的版本
2. gem install bundler
3. cd news_crawlerTW
4. bundle
5. configure conf/myconf.conf
6. 設定cron job. (建議設每10分鐘跑一次)
*/10 * * * * ruby $Script_Home/#{Cralwers.rb}
!因為目前有三個所以要設三次

#other Info
你可以到這個mongodb的saas 上申請一個free的帳號來用(免費500m!)<br>
https://mongolab.com/welcome/<br>
建議在每一個Collections的index把url設成 unqui避免重複抓取！<br>
!提醒!在每一隻bin下面的crawler<br>
ex.<br>
@coll = db['appledaily']<br>
請把裡面的appledaily換成你建的Collections. (如果你沒有按照這邊命名的話.)<br>
<br>
這裡有好心的中文資源:<br>
http://www.codedata.com.tw/database/mongodb-tutorial-1-setting-up-cloud-env/<br>
<br>
在你的系統上如何裝memcatched?<br>
官網有滿滿的資料,要不然可以問谷歌大神<br>
http://memcached.org/<br>
#conf範例
MONGODB_HOST = '127.0.0.1'<br>
MONGODB_PORT = 4567<br>
MONGODB_DBNAME = 'testdb'<br>
MONGODB_ACCOUNT = 'test'<br>
MONGODB_PASSWD = 'test'<br>
#memcatchd server change<br>
lib/mem.rb
更改 localhost:11211 到你的機器+port<br>
def initialize(server="localhost:11211")<br>
#目前爬蟲
1.中時<br>
2.蘋果<br>
3.風傳媒<br>
