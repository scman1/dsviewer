class DsdataController < ApplicationController
  before_action :set_dsdatum, only: [:show, :edit, :update, :destroy]

  # GET /dsdata
  # GET /dsdata.json
  def index
    #@dsdata = Dsdatum.all
    @dsdata = get_digital_specimens
  end

  # GET /dsdata/1
  # GET /dsdata/1.json
  def show

  end

  # GET /dsdata/new
  def new
    @dsdatum = Dsdatum.new
  end

  # GET /dsdata/1/edit
  def edit
  end

  # POST /dsdata
  # POST /dsdata.json
  def create
    @dsdatum = Dsdatum.new(dsdatum_params)

    respond_to do |format|
      if @dsdatum.save
        format.html { redirect_to @dsdatum, notice: 'Dsdatum was successfully created.' }
        format.json { render :show, status: :created, location: @dsdatum }
      else
        format.html { render :new }
        format.json { render json: @dsdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dsdata/1
  # PATCH/PUT /dsdata/1.json
  def update
    respond_to do |format|
      if @dsdatum.update(dsdatum_params)
        format.html { redirect_to @dsdatum, notice: 'Dsdatum was successfully updated.' }
        format.json { render :show, status: :ok, location: @dsdatum }
      else
        format.html { render :edit }
        format.json { render json: @dsdatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dsdata/1
  # DELETE /dsdata/1.json
  def destroy
    @dsdatum.destroy
    respond_to do |format|
      format.html { redirect_to dsdata_url, notice: 'Dsdatum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    require 'net/http'
    # Use callbacks to share common setup or constraints between actions.
    def set_dsdatum
      #retrieve individual specimens
      puts("*****************************************************************")
      puts(params)
      puts("*****************************************************************")
      @dsdatum = get_digital_specimen(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dsdatum_params
       params.require(:dsdatum).permit(:ds_id,:creation_datetime, :creator, 
              :mids_level, :scientific_name, :common_name, :country, :locality,
              :recorded_by, :collection_date, :catalog_number,
              :other_catalog_numbers, :institution_code, :collection_code,
              :stable_identifier, :physical_specimen_id, :determinations,
              :cat_of_life_reference, :image_id)
    end

    def get_credentials
      credential = Credential.first()
      return credential
    end

    def get_digital_specimens
      cordra_credential = get_credentials()
     
      dsr_uri = "http://nsidr.org:8080/objects/?query=type:\"Digital Specimen\"&pageNum=0&pageSize=20"
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

    def get_digital_specimen(ds_id)
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
      ds_specimen = Dsdatum.new(ds_id:json_obj["id"],creation_datetime:json_obj["creationdatetime"], creator:json_obj["creator"], mids_level:json_obj["midslevel"], scientific_name:json_obj["scientificName"], 
        common_name:json_obj["commonName"], country:json_obj["country"], 
        locality:json_obj["locality"], recorded_by:json_obj["recordedBy"],
        collection_date:json_obj["collectionDate"], 
        catalog_number:json_obj["catalogNumber"], 
        other_catalog_numbers:json_obj["otherCatalogNumbers"],
        institution_code:json_obj["institutionCode"], 
        collection_code:json_obj["collectionCode"], 
        stable_identifier:json_obj["stableIdentifier"], 
        physical_specimen_id:json_obj["physicalSpecimenId"], 
        determinations:json_obj["Determinations"], 
        cat_of_life_reference:json_obj["catOfLifeReference"], 
        image_id:json_obj["imageID"])
      return ds_specimen
    end
end
