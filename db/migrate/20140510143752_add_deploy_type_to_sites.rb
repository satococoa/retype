class AddDeployTypeToSites < ActiveRecord::Migration
  def change
    add_column :sites, :deploy_type, :integer, null: false, default: 0
  end
end
