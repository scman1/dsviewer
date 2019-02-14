require "application_system_test_case"

class DsdataTest < ApplicationSystemTestCase
  setup do
    @dsdatum = dsdata(:one)
  end

  test "visiting the index" do
    visit dsdata_url
    assert_selector "h1", text: "Dsdata"
  end

  test "creating a Dsdatum" do
    visit dsdata_url
    click_on "New Dsdatum"

    fill_in "Cat of life reference", with: @dsdatum.cat_of_life_reference
    fill_in "Catalog number", with: @dsdatum.catalog_number
    fill_in "Collection code", with: @dsdatum.collection_code
    fill_in "Collection date", with: @dsdatum.collection_date
    fill_in "Common name", with: @dsdatum.common_name
    fill_in "Country", with: @dsdatum.country
    fill_in "Creation datetime", with: @dsdatum.creation_datetime
    fill_in "Creator", with: @dsdatum.creator
    fill_in "Determinations", with: @dsdatum.determinations
    fill_in "Ds", with: @dsdatum.ds_id
    fill_in "Image", with: @dsdatum.image_id
    fill_in "Institution code", with: @dsdatum.institution_code
    fill_in "Locality", with: @dsdatum.locality
    fill_in "Mids level", with: @dsdatum.mids_level
    fill_in "Other catalog numbers", with: @dsdatum.other_catalog_numbers
    fill_in "Physical specimen", with: @dsdatum.physical_specimen_id
    fill_in "Recorded by", with: @dsdatum.recorded_by
    fill_in "Scientific name", with: @dsdatum.scientific_name
    fill_in "Stable identifier", with: @dsdatum.stable_identifier
    click_on "Create Dsdatum"

    assert_text "Dsdatum was successfully created"
    click_on "Back"
  end

  test "updating a Dsdatum" do
    visit dsdata_url
    click_on "Edit", match: :first

    fill_in "Cat of life reference", with: @dsdatum.cat_of_life_reference
    fill_in "Catalog number", with: @dsdatum.catalog_number
    fill_in "Collection code", with: @dsdatum.collection_code
    fill_in "Collection date", with: @dsdatum.collection_date
    fill_in "Common name", with: @dsdatum.common_name
    fill_in "Country", with: @dsdatum.country
    fill_in "Creation datetime", with: @dsdatum.creation_datetime
    fill_in "Creator", with: @dsdatum.creator
    fill_in "Determinations", with: @dsdatum.determinations
    fill_in "Ds", with: @dsdatum.ds_id
    fill_in "Image", with: @dsdatum.image_id
    fill_in "Institution code", with: @dsdatum.institution_code
    fill_in "Locality", with: @dsdatum.locality
    fill_in "Mids level", with: @dsdatum.mids_level
    fill_in "Other catalog numbers", with: @dsdatum.other_catalog_numbers
    fill_in "Physical specimen", with: @dsdatum.physical_specimen_id
    fill_in "Recorded by", with: @dsdatum.recorded_by
    fill_in "Scientific name", with: @dsdatum.scientific_name
    fill_in "Stable identifier", with: @dsdatum.stable_identifier
    click_on "Update Dsdatum"

    assert_text "Dsdatum was successfully updated"
    click_on "Back"
  end

  test "destroying a Dsdatum" do
    visit dsdata_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dsdatum was successfully destroyed"
  end
end
