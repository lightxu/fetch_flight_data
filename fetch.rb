# require 'watir-webdriver'
require 'watir'
require 'timeout'

File.open("flight_price.csv", "w") do |csv_file|
  csv_file.puts "Timestamp, price, plane1, plane2, plane3"
end

while (1)
  print "Fetch start"
  browser = Watir::Browser.new :chrome

  # Tianxun
  #　browser.goto "http://www.tianxun.cn/transport/flights/pvg/pit/140805/airfares-from-shanghai-pu-dong-to-pittsburgh-int-l-apt.-in-august-2014.html"


  # 全日空
  browser.goto "http://www.ana.co.jp/asw/wws/cn/c/"


  # Doesn't work.
  # single = browser.radio :id, "ticket_2"
  # single.click
  
  # from = browser.text_field :name, "DepApoText"
  # from.set "上海(浦东)/Shanghai(Pudong)[PVG]"
  # to = browser.text_field :name, "ArrApoText"
  # to.set "匹兹堡(PIT)/Pittsburgh[PIT]"

  # browser.link(:id, "wayTo").click
  # browser.link(:id, "calendar-next").click
  # browser.link(:id, "0805").click
  
  browser.execute_script '$("#ticket_2").click()'
  browser.execute_script '$("#reservation > form > dl.form-box.spl14 > dd:nth-child(3) > a").click()'
  browser.execute_script '$("#CN").click()'
  browser.execute_script '$("#apo_SHA").click()'
  browser.execute_script '$("#reservation > form > dl.form-box.spl14 > dd.btn-change.spt10 > a").click()'
  browser.execute_script '$("#US").click()'
  browser.execute_script '$("#apo_PIT").click()'
  
  browser.execute_script '$("#wayTo").click()'
  browser.execute_script '$("#calendar-next").click()'
  browser.execute_script '$("#0805").click()'

  form = browser.form :name, "segConditionForm"
  form.submit

  if not browser.table(:xpath, "//*[@id=\"bodyArea\"]/table[15]").exists?
    puts "Please input verification code in the webpage XD.\n Then press enter in this console."
    gets
  end
  File.open("flight_price.csv", "a") do |csv_file|
    for i in 0...5
      row = "#{Time.now}, " +
        browser.span(:xpath, "//*[@id=\"bodyArea\"]/table[#{15+i}]/tbody/tr[1]/td/table/tbody/tr/td[4]/span[1]").text.gsub(/,|元|～/, "") +
        ", " +
        browser.td(:xpath, "//*[@id=\"bodyArea\"]/table[#{15+i}]/tbody/tr[3]/td[2]").text +
        ", " +
        browser.td(:xpath, "//*[@id=\"bodyArea\"]/table[#{15+i}]/tbody/tr[4]/td[2]").text +
        ", " +
        browser.td(:xpath, "//*[@id=\"bodyArea\"]/table[#{15+i}]/tbody/tr[5]/td[2]").text
      puts row
      csv_file.puts row
    end
  end

  browser.close
  
  # http://stackoverflow.com/questions/22796591/ruby-gets-wait-2-seconds-and-then-set-the-value
  begin
    puts "Press enter if you want to pause, I will wait for 5 seconds..."
    wait = Timeout::timeout(5) do
      gets
    end
    puts "Aye aye captain, please press enter again to continue."
    gets
    puts "I will start working immediately!"
  rescue Timeout::Error
    puts "Time out! Let's wait for 30 minutes to fetch next flight data"
    sleep 30*60
    # sleep 1
  end
 end
