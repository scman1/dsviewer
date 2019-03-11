# retrieve DS object schema
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
url = URI.parse("http://nsidr.org:8080/objects/?query=type:\"Schema\"")

req = Net::HTTP::Get.new(url)
req.basic_auth(v1, v2)
res= Net::HTTP.start(url.hostname, url.port){|http| http.request(req)}
#puts(res.body)

jsonv = JSON.parse(res.body)
ds_schema=[]
for result in jsonv["results"]
  obj = result["content"]["name"]
  puts(obj)
  if obj == "Digital Specimen" 
    puts("DS found")
    ds_schema = result["content"]["schema"]
  end
end

puts("Required: " + ds_schema["required"].length().to_s())
puts(ds_schema["required"])

puts("properties: " + ds_schema["properties"].length.to_s )
puts(ds_schema["properties"].keys)

for ds_property_name in ds_schema["properties"].keys
  puts(ds_property_name)
end


puts(ds_schema)

