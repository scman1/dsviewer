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
url = URI.parse("http://nsidr.org:8080/objects/?type=Digital%20Specimen&suffix=B100003483")
  ds={
       "id": "",
       "creator": "",
       "midslevel":2,
       "scientificName": "Agathis palmerstonii (F.Muell.)",
       "country": "Australia",
       "locality": "Queensland",
       "decimalLat/Long": [],
       "recordedBy": "F.M.Bailey",
       "collectionDate": "1932-04-08",
       "catalogNumber": "B 10 0003483",
       "otherCatalogNumbers": "",
       "collectionCode": "Australia: Queensland",
       "institutionCode": "B",
       "stableIdentifier": "http://herbarium.bgbm.org/object/B100003483",
       "physicalSpecimenId": "B 10 0003483",
       "Determinations": "Yes"
     }

header = {'Content-Type': 'text/json'}
req = Net::HTTP::Post.new(url, header)
req.basic_auth(v1, v2)
req.body = ds.to_json
puts(ds)
res= Net::HTTP.start(url.hostname, url.port){|http| http.request(req)}

puts(res.body)

jsonv = JSON.parse(res.body)

puts(jsonv)
