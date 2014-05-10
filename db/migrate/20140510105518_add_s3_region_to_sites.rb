class AddS3RegionToSites < ActiveRecord::Migration
  def change
    add_column :sites, :s3_region, :string
  end
end
