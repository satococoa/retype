class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.belongs_to :site, index: true
      t.string :title
      t.string :template
      t.string :path
      t.text :data

      t.timestamps
    end
  end
end
