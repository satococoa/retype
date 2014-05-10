class AddThemeToSites < ActiveRecord::Migration
  def change
    add_column :sites, :theme, :string
  end
end
