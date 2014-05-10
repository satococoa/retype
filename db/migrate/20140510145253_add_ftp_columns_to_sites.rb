class AddFtpColumnsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :ftp_host, :string
    add_column :sites, :ftp_directory, :string
    add_column :sites, :ftp_user, :string
    add_column :sites, :ftp_password, :string
  end
end
