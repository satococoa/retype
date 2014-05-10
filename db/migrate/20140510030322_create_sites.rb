class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :s3_access_key
      t.string :s3_secret_key

      t.timestamps
    end
  end
end
