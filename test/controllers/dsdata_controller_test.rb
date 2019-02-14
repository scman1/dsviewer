require 'test_helper'

class DsdataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dsdatum = dsdata(:one)
  end

  test "should get index" do
    get dsdata_url
    assert_response :success
  end

  test "should get new" do
    get new_dsdatum_url
    assert_response :success
  end

  test "should create dsdatum" do
    assert_difference('Dsdatum.count') do
      post dsdata_url, params: { dsdatum: { cat_of_life_reference: @dsdatum.cat_of_life_reference, catalog_number: @dsdatum.catalog_number, collection_code: @dsdatum.collection_code, collection_date: @dsdatum.collection_date, common_name: @dsdatum.common_name, country: @dsdatum.country, creation_datetime: @dsdatum.creation_datetime, creator: @dsdatum.creator, determinations: @dsdatum.determinations, ds_id: @dsdatum.ds_id, image_id: @dsdatum.image_id, institution_code: @dsdatum.institution_code, locality: @dsdatum.locality, mids_level: @dsdatum.mids_level, other_catalog_numbers: @dsdatum.other_catalog_numbers, physical_specimen_id: @dsdatum.physical_specimen_id, recorded_by: @dsdatum.recorded_by, scientific_name: @dsdatum.scientific_name, stable_identifier: @dsdatum.stable_identifier } }
    end

    assert_redirected_to dsdatum_url(Dsdatum.last)
  end

  test "should show dsdatum" do
    get dsdatum_url(@dsdatum)
    assert_response :success
  end

  test "should get edit" do
    get edit_dsdatum_url(@dsdatum)
    assert_response :success
  end

  test "should update dsdatum" do
    patch dsdatum_url(@dsdatum), params: { dsdatum: { cat_of_life_reference: @dsdatum.cat_of_life_reference, catalog_number: @dsdatum.catalog_number, collection_code: @dsdatum.collection_code, collection_date: @dsdatum.collection_date, common_name: @dsdatum.common_name, country: @dsdatum.country, creation_datetime: @dsdatum.creation_datetime, creator: @dsdatum.creator, determinations: @dsdatum.determinations, ds_id: @dsdatum.ds_id, image_id: @dsdatum.image_id, institution_code: @dsdatum.institution_code, locality: @dsdatum.locality, mids_level: @dsdatum.mids_level, other_catalog_numbers: @dsdatum.other_catalog_numbers, physical_specimen_id: @dsdatum.physical_specimen_id, recorded_by: @dsdatum.recorded_by, scientific_name: @dsdatum.scientific_name, stable_identifier: @dsdatum.stable_identifier } }
    assert_redirected_to dsdatum_url(@dsdatum)
  end

  test "should destroy dsdatum" do
    assert_difference('Dsdatum.count', -1) do
      delete dsdatum_url(@dsdatum)
    end

    assert_redirected_to dsdata_url
  end
end
