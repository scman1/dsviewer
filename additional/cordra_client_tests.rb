#https://zenodo.org/record/1487298 
#the png's are an example 
#Git Hub Repository fot user stories
#https://github.com/DiSSCo/user-stories 
#https://opendata.cines.fr/herbadrop-api/rest/data/search?P04450677
#https://opendata.cines.fr/herbadrop-api/rest/data/mnhn/P04450677
#https://opendata.cines.fr/herbadrop-api/rest/thumbnail/mnhnftp/P04450677/P04450677.jpg




#get a list of DS
list_ds=CordraRestClient::DigitalObject.search("Digital Specimen",0, 10)

#get DS schema
result=CordraRestClient::DigitalObject.get_schema("Digital Specimen".gsub(" ","%20"))
do_schema = JSON.parse(result.body)
# create a new class for the DS from the schema
do_properties = do_schema["properties"].keys
ds_class = CordraRestClient::DigitalObjectFactory.create_class "Digital Specimen".gsub(" ",""), do_properties 

#convert each of the results into a DS object and put it in a new array
ds_return=[] 
list_ds["results"].each do |ds|
  new_ds = do_class.new 
  ds_data = ds["content"]
  CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, ds_data
  ds_return.push(new_ds)
  ds_data.each do |field, arg|
    instance_var = field.gsub('/','_')
    instance_var = instance_var.gsub(' ','_')
    puts(field+": " + arg.to_s + " " + new_ds.instance_variable_get("@#{instance_var}").to_s)
  end
end
#end
CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, cdo.content
