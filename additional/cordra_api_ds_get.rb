#retrieve object by id
#!/usr/bin/env ruby

require "open-uri"
require "net/https"
require "json"

if __FILE__ == $0
  # Set your customer name, username, and password on the command line 
  v1 = ARGV[0]
  v2 = ARGV[1]
end
# need retries to make sure we get the right response from the server
#url = URI.parse('http://131.251.172.30:8080/objects/20.5000.1025/B100003484')
url = URI.parse('http://nsidr.org:8080/objects/20.5000.1025/B100003484')


req = Net::HTTP::Get.new(url)
req.basic_auth(v1, v2)
res= Net::HTTP.start(url.hostname, url.port){|http| http.request(req)}

jsonv = JSON.parse(res.body)

puts(jsonv)
