class DsdataController < ApplicationController
  before_action :set_dsdatum, only: [:show, :edit, :update, :destroy]

  # GET /dsdata
  # GET /dsdata.json
  def index
    @dsdata = Dsdatum.all
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
    # Use callbacks to share common setup or constraints between actions.
    def set_dsdatum
      @dsdatum = Dsdatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dsdatum_params
      params.require(:dsdatum).permit(:ds_id, :creation_datetime, :creator, :mids_level, :scientific_name, :common_name, :country, :locality, :recorded_by, :collection_date, :catalog_number, :other_catalog_numbers, :institution_code, :collection_code, :stable_identifier, :physical_specimen_id, :determinations, :cat_of_life_reference, :image_id)
    end
end
