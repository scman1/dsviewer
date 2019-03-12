class DsdataController < ApplicationController
  before_action :set_dsdatum, only: [:show, :edit, :update, :destroy]
  # GET /dsdata
  # GET /dsdata.json
  def index
    if not(params.key?("page"))
      num_page = 0
    else
      num_page = params[:page].to_i-1
    end
    if not(params.key?("items"))
      items = 10
    else
      items = params[:items].to_i
    end
    dsobj = DsDataRestApi.new
    @dsdata = dsobj.get_dss(num_page, items)
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
    #puts dsdatum_params
    puts("*****************GET /dsdata/1/edit*****************")
    puts(params)
    puts(@dsdatum.id)
    puts(@dsdatum.new_record?)
    puts("****************************************************")
  end

  # POST /dsdata
  # POST /dsdata.json
  def create
    @dsdatum = Dsdatum.new(dsdatum_params)
    dsdatum = dsdatum_params
    dsobj = DsDataRestApi.new
    #puts("*******************POST /dsdata*********************")
    specimen_id = dsdatum["ds_id"]
    dsdatum["ds_id"] =""
    puts(dsdatum) #params[:dsdatum].to_json)
    response= dsobj.add_ds(specimen_id, dsdatum)
    puts(response=="200")
    puts (response)
    #puts("****************************************************")
   
    respond_to do |format|
      if response == "200"
        format.html { redirect_to "/dsdata/"+specimen_id, notice: 'Specimen was successfully created.' }
        format.json { render :show, status: :created, location: @dsdatum }
      else
        format.html { render :new, notice: 'Specimen could not be created.' }
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
    include RestApis
    # Use callbacks to share common setup or constraints between actions.
    def set_dsdatum
      dsobj = DsDataRestApi.new
      @dsdatum = dsobj.get_ds(params[:id])
      puts("*****************set_dsdatum************************")
      puts(@dsdatum)
      if @dsdatum.id.nil?()
        puts("rails DS ID is empty")
        @dsdatum.id = 99999
        puts(@dsdatum.id)
      end
      puts("****************************************************")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dsdatum_params
       puts("*****************dsdatum_params********************")
       puts(params)
       params.require(:dsdatum).permit(:ds_id,:creation_datetime, :creator, 
              :mids_level, :scientific_name, :common_name, :country, :locality,
              :recorded_by, :collection_date, :catalog_number,
              :other_catalog_numbers, :institution_code, :collection_code,
              :stable_identifier, :physical_specimen_id, :determinations,
              :cat_of_life_reference, :image_id)
    end
end
