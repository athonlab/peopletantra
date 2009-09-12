# encoding: UTF-8
require 'rubygems'
require 'hpricot'
require 'net/http'
require 'uri'
class Parser
  def self.extract_links_to_members stream
    doc = Hpricot(stream)
    doc.search('.middleColumn>ul li a').collect{|link| link.attributes['href'] }
  end

  # parse members biodata  
  def self.extract_member stream
    member = {}
    doc = Hpricot stream
    header = nil
    doc.search('.table1 tr td').each{|table_data| 
      unless table_data.search('strong').empty? # even
        # collecting header
        header = table_data.search('strong').inner_html
      else # odd
        member[header] = table_data.inner_text
        #puts table_data.inspect
      end
    }
    member
  end
end 

# extract links to members
url = URI.parse('http://india.gov.in/govt/loksabha.php')
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
}
Parser.extract_links_to_members(res.body).each do |link|
  # extracting mp_code 
  mp_code = link.split('=').last
  url = URI.parse("http://india.gov.in/govt/loksabhampbiodata.php?mpcode=#{mp_code}")
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  puts Parser.extract_member(res.body).inspect
  break
end
