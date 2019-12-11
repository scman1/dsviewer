class SpecimensController < ApplicationController
  before_action :set_specimen, only: [:show, :edit, :update, :destroy]
  # GET /specimens
  # GET /specimens.json
  def index
    #get the list of digital specimens from api
    if not(params.key?("page"))
      session[:num_page] = session.fetch(:num_page, 1)
    else
      session[:num_page] = params[:page].to_i
    end
    if not(params.key?("items"))
      session[:page_size] = session.fetch(:page_size, 50)
    else
      session[:page_size] = params[:items].to_i
    end
    if not(params.key?("search"))
      session[:search] = session.fetch(:search, "")
    else
      session[:search] = params[:search]
    end
    puts("*****************GET /dsdata*****************")
    # get DS list from CORDRA
    begin
      # enable search
      @search = session[:search]
      query = "type:DigitalSpecimen"
      unless @search.to_s.strip.empty?
        if (@search.include?":") && (@search.include?"/") || (@search.downcase.include?" and ") || (@search.downcase.include?" or ")
          # the user seems to do a search using a Lucene query syntax, so keep it
          query += " AND (" + @search.gsub(" and "," AND ").gsub(" or ", " OR ") + ")"
        else
          # the user doesn't seems to do a search using a lucene query syntax, so we escape it
          query += " AND (\"" + @search.gsub(/([\\|\+|\-|\!|\(|)|\:|\^|\[|\]|\"|\{|\~|\*|\?|\||\&|\/])/, '\\\\\1') + "\")"
        end
      end

      # enable pagination
      @current_page = session[:num_page]
      @page_size = session[:page_size]

      # Get digital specimens from CORDRA
      list_ds = CordraRestClient::DigitalObject.advanced_search(query,@current_page-1,@page_size)

      @total_records = list_ds["size"]
      @total_pages = (@total_records.to_f/@page_size).ceil


      # get DS schema from CORDRA
      result=CordraRestClient::DigitalObject.get_schema("DigitalSpecimen")
      do_schema = JSON.parse(result.body)
      # create a new class for the DS from the schema
      do_properties = do_schema["properties"].keys
      ds_class = CordraRestClient::DigitalObjectFactory.create_class "DigitalSpecimen", do_properties

      # convert each of the results into a DS object and 
      # build a list of DS objects
      ds_return=[]
      list_ds["results"].each do |ds|
        new_ds = ds_class.new
        ds_data = ds["content"]
        CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, ds_data
        ds_return.push(new_ds)
      end
    rescue Faraday::ConnectionFailed => e
      list_ds =  helpers.load_data_json('ds_list.json')
      @do_schema = helpers.load_data_json('ds_schema.json')
      @do_properties = @do_schema["properties"].keys
      puts @properties
      ds_class = CordraRestClient::DigitalObjectFactory.create_class "DigitalSpecimen", @do_properties
      ds_return=[]
      list_ds["results"].each do |ds|
        new_ds = ds_class.new
        ds_data = ds["content"]
        CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, ds_data
        ds_return.push(new_ds)
      end
      puts e
    end

    #end
    @dsdata = ds_return
    # puts("*****************GET /dsobj*****************")
    # @dsdata.each do |dsdatum|
    #   puts dsdatum.id
    # end
    # puts("*****************GET /dsobj*****************")
  end

  # GET /specimens/1
  # GET /specimens/1.json
  def show

  end

  # GET /dsdata/new
  def new
    @dsdatum = new_specimen
  end

  # GET /dsdata/1/edit
  def edit
    #puts dsdatum_params
    puts("*****************GET /dsdata/1/edit*****************")
    puts(params)
    puts(@dsdatum.id)
    #puts(@dsdatum.new_record?)
    puts("****************************************************")
  end

  #~ # POST /dsdata
  #~ # POST /dsdata.json
  #~ def create
  #~ @dsdatum = Dsdatum.new(dsdatum_params)
  #~ dsdatum = dsdatum_params
  #~ dsobj = DsDataRestApi.new
  #~ #puts("*******************POST /dsdata*********************")
  #~ specimen_id = dsdatum["ds_id"]
  #~ dsdatum["ds_id"] =""
  #~ puts(dsdatum) #params[:dsdatum].to_json)
  #~ response= dsobj.add_ds(specimen_id, dsdatum)
  #~ puts(response.code=="200")
  #~ #puts("****************************************************")

  #~ respond_to do |format|
  #~ if response.code == "200"
  #~ format.html { redirect_to "/dsdata/"+specimen_id, notice: 'Specimen was successfully created.' }
  #~ format.json { render :show, status: :created, location: @dsdatum }
  #~ else
  #~ dsdatum["errors"]=response.body
  #~ format.html { render :new, notice: 'Specimen could not be created.' }
  #~ format.json { render json: @dsdatum.errors, status: :unprocessable_entity }
  #~ end
  #~ end
  #~ end

  #~ # PATCH/PUT /dsdata/1
  #~ # PATCH/PUT /dsdata/1.json
  #~ def update
  #~ puts("*****************PATCH/PUT /dsdata/1************************")
  #~ puts(@dsdatum)
  #~ puts("****************************************************")
  #~ respond_to do |format|
  #~ if @dsdatum.update(dsdatum_params)
  #~ format.html { redirect_to @dsdatum, notice: 'Dsdatum was successfully updated.' }
  #~ format.json { render :show, status: :ok, location: @dsdatum }
  #~ else
  #~ format.html { render :edit }
  #~ format.json { render json: @dsdatum.errors, status: :unprocessable_entity }
  #~ end
  #~ end
  #~ end

  #~ # DELETE /dsdata/1
  #~ # DELETE /dsdata/1.json
  #~ def destroy
  #~ @dsdatum.destroy
  #~ respond_to do |format|
  #~ format.html { redirect_to dsdata_url, notice: 'Dsdatum was successfully destroyed.' }
  #~ format.json { head :no_content }
  #~ end
  #~ end

  private
  include CordraRestClient
  # Use callbacks to share common setup or constraints between actions.
  def set_specimen

    # A. get digital object
    begin
      specimen_id = params[:id].gsub("_","-")
      cdo = CordraRestClient::DigitalObject.find("20.5000.1025/#{specimen_id}")

      prov_records = CordraRestClient::DigitalObject.call_instance_method("20.5000.1025/#{specimen_id}","getProvenanceRecords",nil,nil)
      @provenance_records = prov_records["provenanceRecords"]

      # Check object id and type
      puts cdo.id
      puts cdo.type
      # B. get schema
      #     The schema will be used to build a DO class dinamically
      result=CordraRestClient::DigitalObject.get_schema(cdo.type)
      @do_schema = JSON.parse(result.body)
      # C. build new class using schema
      @do_properties = @do_schema["properties"].keys
      do_c = CordraRestClient::DigitalObjectFactory.create_class cdo.type, @do_properties
      new_ds = do_c.new
      # the DO contents are a hash
      # assing object values in content to class
      CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, cdo.content
      @dsdatum = new_ds
    rescue => error
      cdo = helpers.load_data_json('ds_single.json')
      puts cdo["content"]
      @do_schema = helpers.load_data_json('ds_schema.json')
      @do_properties = @do_schema["properties"].keys
      puts @properties
      do_c = CordraRestClient::DigitalObjectFactory.create_class "DigitalSpecimen", @do_properties
      new_ds = do_c.new
      CordraRestClient::DigitalObjectFactory.assing_attributes new_ds, cdo["content"]
      @dsdatum = new_ds
      prov_records =  helpers.load_data_json('ds_provenance_records.json')
      @provenance_records = prov_records["provenanceRecords"]
    end

    puts("*****************set_specimen************************")
    puts(@dsdatum)
    puts(@do_properties)
    puts(@do_schema["properties"])
    #@dsdatum.ds_id = @dsdatum.ds_id.split('/')[1]
    puts(@dsdatum.id)

    puts("****************************************************")
  end

  def new_specimen

    # A. get new digital object
    # B. get schema
    #     The schema will be used to build a DO class dinamically
    result=CordraRestClient::DigitalObject.get_schema("DigitalSpecimen")
    @do_schema = JSON.parse(result.body)
    # C. build new class using schema
    @do_properties = @do_schema["properties"].keys
    do_c = CordraRestClient::DigitalObjectFactory.create_class "DigitalSpecimen", @do_properties
    do_c.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def digital_object_params
    puts("*****************specimen_params********************")
    puts(params)
    dsobj = DsDataRestApi.new

    @dsdatum = dsobj.parse_params(params)
    params.require(:dsdatum).permit(:ds_id,:creation_datetime, :creator,
                                    :mids_level, :scientific_name, :common_name, :country, :locality,
                                    :recorded_by, :collection_date, :catalog_number,
                                    :other_catalog_numbers, :institution_code, :collection_code,
                                    :stable_identifier, :physical_specimen_id, :determinations,
                                    :cat_of_life_reference, :image_id)
  end
end
