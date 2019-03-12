module RestApis
  class DsDataRestApi
    require 'net/http' 
    def get_credentials
      credential = Credential.where(:server_type => 'cordra', :default=>true, :in_use=>true).first()
      return credential
    end
    
    def get_dss(page, items)
      cordra_credential = get_credentials()
      type="Digital Specimen"
      page_items=items
      page_num=page
      dsr_uri = "http://nsidr.org:8080/objects/?query=type:\""+type+
        "\"&pageNum="+ page_num.to_s+"&pageSize="+page_items.to_s
      parsed_uri = URI.parse(dsr_uri)
      
      req = Net::HTTP::Get.new(parsed_uri) 
      req.basic_auth(cordra_credential.login, cordra_credential.password)
      res= Net::HTTP.start(parsed_uri.hostname, parsed_uri.port){|http| http.request(req)}
      
      json_obj = JSON.parse(res.body)
      #puts(json_obj["results"])
      ds_list=[]
      for item in json_obj["results"]
        dsdatum = Dsdatum.new(ds_id:item["content"]["id"], mids_level:item["content"]["midslevel"],
               scientific_name:item["content"]["scientificName"],country:item["content"]["country"])
	if !item["content"]["id"].nil? 
          if dsdatum.ds_id.include? "/"
            dsdatum.ds_id = dsdatum.ds_id.split('/')[1]
          end 
          ds_list.push(dsdatum)
        end
      end
      return ds_list
    end

    def get_ds(ds_id)
      cordra_credential = get_credentials()
     
      dsr_uri = "http://nsidr.org:8080/objects/20.5000.1025/"+ds_id
      puts(dsr_uri)
      parsed_uri = URI.parse(dsr_uri)
      
      req = Net::HTTP::Get.new(parsed_uri) 
      req.basic_auth(cordra_credential.login, cordra_credential.password)
      res= Net::HTTP.start(parsed_uri.hostname, parsed_uri.port){|http| http.request(req)}
      
      json_obj = JSON.parse(res.body)
      puts(json_obj)
      ds_specimen = nil
      ds_specimen = Dsdatum.new(ds_id:json_obj["id"],
        creation_datetime:json_obj["creationdatetime"],
        creator:json_obj["creator"], mids_level:json_obj["midslevel"], 
        scientific_name:json_obj["scientificName"], 
        common_name:json_obj["commonName"], country:json_obj["country"], 
        locality:json_obj["locality"], recorded_by:json_obj["recordedBy"],
        collection_date:json_obj["collectionDate"], 
        catalog_number:json_obj["catalogNumber"], 
        other_catalog_numbers:json_obj["otherCatalogNumbers"],
        institution_code:json_obj["institutionCode"], 
        collection_code:json_obj["collectionCode"], 
        stable_identifier:json_obj["stableIdentifier"], 
        physical_specimen_id:json_obj["physicalSpecimenId"], 
        determinations:json_obj["D7eterminations"], 
        cat_of_life_reference:json_obj["catOfLifeReference"], 
        image_id:json_obj["imageID"])
      return ds_specimen
    end

    def add_ds(ds_id, ds_data)
      cordra_credential = get_credentials()
      dsr_uri = "http://nsidr.org:8080/objects/?type=Digital%20Specimen&suffix="+ds_id
      ds={
        "id": "",
        "creator": "",
        "midslevel":ds_data["mids_level"].to_i,
        "scientificName": ds_data["scientific_name"],
        "country": ds_data["country"],
        "locality": ds_data["locality"],
        "decimalLat/Long": [],
        "recordedBy": ds_data["recorded_by"],
        "collectionDate": ds_data["collection_date"].to_s,
        "catalogNumber":  ds_data["catalog_number"],
        "otherCatalogNumbers": ds_data["other_catalog_numbers"],
        "collectionCode": ds_data["collection_code"],
        "institutionCode":  ds_data["institution_code"],
        "stableIdentifier": ds_data["stable_identifier"],
        "physicalSpecimenId": ds_data["physical_specimen_id"],
        "Determinations": ds_data["determinations"]
      }
      parsed_uri = URI.parse(dsr_uri)
      header = {'Content-Type': 'text/json'}
      req = Net::HTTP::Post.new(parsed_uri, header)
      req.basic_auth(cordra_credential.login, cordra_credential.password)
      req.body = ds.to_json
   
      puts("****************************************************")
      puts(ds_id)
      puts(ds.to_json)
      puts("****************************************************")
      res= Net::HTTP.start(parsed_uri.hostname, parsed_uri.port){|http| http.request(req)}
      puts(res.body)
      puts(res.code)
      return res.code
    end
  end#class
end#module