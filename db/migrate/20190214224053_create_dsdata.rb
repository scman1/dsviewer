class CreateDsdata < ActiveRecord::Migration[5.2]
  def change
    create_table :dsdata do |t|
      t.string :ds_id
      t.datetime :creation_datetime
      t.string :creator
      t.integer :mids_level
      t.string :scientific_name
      t.string :common_name
      t.string :country
      t.string :locality
      t.string :recorded_by
      t.date :collection_date
      t.string :catalog_number
      t.string :other_catalog_numbers
      t.string :institution_code
      t.string :collection_code
      t.string :stable_identifier
      t.string :physical_specimen_id
      t.string :determinations
      t.string :cat_of_life_reference
      t.string :image_id

      t.timestamps
    end
  end
end
